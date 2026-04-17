//
//  HomeViewController.swift
//  AppSOS
//
//  Created by Erick Chunga on 9/04/26.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

protocol SeleccionVehiculoDelegate: AnyObject {
    func vehiculoElegidoParaSOS(_ vehiculo: VehiculoEntity)
}

class HomeViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var bottomPanel: UIView!
    @IBOutlet weak var catScrollView: UIScrollView!
    @IBOutlet weak var btnSOS: UIButton!
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
            super.viewDidLoad()
            setupLocation()
        }

        func setupLocation() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
        }
        
        @IBAction func btnSOSTapped(_ sender: UIButton) {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            do {
                let conteo = try context.count(for: VehiculoEntity.fetchRequest())
                if conteo == 0 {
                    let alerta = UIAlertController(title: "Garaje Vacío", message: "Registra un vehículo primero.", preferredStyle: .alert)
                    alerta.addAction(UIAlertAction(title: "OK", style: .default))
                    present(alerta, animated: true)
                } else {
                    performSegue(withIdentifier: "mostrarElegirVehiculo", sender: nil)
                }
            } catch {
                print("Error: \(error)")
            }
        }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "mostrarElegirVehiculo",
               let destino = segue.destination as? ElegirVehiculoViewController {
                destino.delegado = self
            }
            else if segue.identifier == "irARastreo",
                    let destino = segue.destination as? RastreoViewController,
                    let vehiculoElegido = sender as? VehiculoEntity {
                
                destino.vehiculoAveriado = vehiculoElegido
            }
        }
    }

    extension HomeViewController: SeleccionVehiculoDelegate {
        func vehiculoElegidoParaSOS(_ vehiculo: VehiculoEntity) {
            let placa = vehiculo.placa ?? ""
            print("Preparando rescate para: \(placa)")
            
            performSegue(withIdentifier: "irARastreo", sender: vehiculo)
        }
    }
