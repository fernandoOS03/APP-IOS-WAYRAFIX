//
//  RastreoViewController.swift
//  AppSOS
//
//  Created by Erick Chunga on 12/04/26.
//

import UIKit
import MapKit
import CoreData

class RastreoViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var infoPanelView: UIView!
    @IBOutlet weak var perfilImageView: UIImageView!
    @IBOutlet weak var lblNombreMecanico: UILabel!
    @IBOutlet weak var lblEstadoServicio: UILabel!
    @IBOutlet weak var btnCancelar: UIButton!
    
    var vehiculoAveriado: VehiculoEntity?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
            super.viewDidLoad()
            configurarUI()
        }
        
        func configurarUI() {
            perfilImageView.layer.cornerRadius = perfilImageView.frame.height / 2
            perfilImageView.clipsToBounds = true
            
            lblNombreMecanico.text = "Buscando mecánico..."
            lblEstadoServicio.text = "Por favor, espera un momento"
            btnCancelar.layer.cornerRadius = 10
            
            if let auto = vehiculoAveriado {
                self.title = "Rescate: \(auto.placa ?? "")"
            }
        }

        func guardarEnHistorial(estado: String) {
            let nuevoServicio = ServicioEntity(context: self.context)
            
            let marca = vehiculoAveriado?.marca ?? "Vehículo"
            let placa = vehiculoAveriado?.placa ?? "Sin Placa"
            
            nuevoServicio.titulo = "Asistencia para \(marca) (\(placa))"
            nuevoServicio.fecha = Date()
            nuevoServicio.estado = estado
            
            do {
                try context.save()
                print("Servicio guardado en el historial con éxito")
            } catch {
                print("Error al guardar historial: \(error)")
            }
        }

    @IBAction func btnCancelar(_ sender: UIButton) {
        guardarEnHistorial(estado: "Cancelado por el usuario")
        self.navigationController?.popViewController(animated: true)
    }

}
