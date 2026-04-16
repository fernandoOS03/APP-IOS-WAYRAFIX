//
//  GarageViewController.swift
//  AppSOS
//
//  Created by Erick Chunga on 12/04/26.
//

import UIKit
internal import CoreData

class GarageViewController: UIViewController {

    @IBOutlet weak var viewVacía: UIView!
    @IBOutlet weak var tblVehiculos: UITableView!
    
    var listaVehiculos: [VehiculoEntity] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        tblVehiculos.delegate = self
        tblVehiculos.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cargarVehiculos()
    }
    
    func cargarVehiculos() {
        let solicitud: NSFetchRequest<VehiculoEntity> = VehiculoEntity.fetchRequest()
        
        do {
            listaVehiculos = try context.fetch(solicitud)
            if listaVehiculos.isEmpty {
                viewVacía.isHidden = false
                tblVehiculos.isHidden = true
            } else {
                viewVacía.isHidden = true
                tblVehiculos.isHidden = false
                tblVehiculos.reloadData()
            }
        } catch {
            print("Error al cargar los vehículos: \(error)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mostrarDetalleVehiculo",
           let destino = segue.destination as? DetalleVehiculoViewController,
           let vehiculoElegido = sender as? VehiculoEntity {
            
        }
    }
}

extension GarageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaVehiculos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "vehiculoCell", for: indexPath)
        let vehiculo = listaVehiculos[indexPath.row]
        
        celda.textLabel?.text = vehiculo.placa
        celda.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        let marca = vehiculo.marca ?? ""
        let modelo = vehiculo.modelo ?? ""
        let anio = vehiculo.anio
        
        celda.detailTextLabel?.text = "\(marca) \(modelo) - \(anio)"
        celda.detailTextLabel?.textColor = .darkGray
        celda.imageView?.image = UIImage(systemName: "car.side.fill")
        
        return celda
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vehiculo = listaVehiculos[indexPath.row]
        
        performSegue(withIdentifier: "mostrarDetalleVehiculo", sender: vehiculo)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let autoAEliminar = listaVehiculos[indexPath.row]
            
            context.delete(autoAEliminar)
            
            do {
                try context.save()
                listaVehiculos.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                if listaVehiculos.isEmpty {
                    viewVacía.isHidden = false
                    tblVehiculos.isHidden = true
                }
            } catch {
                print("Error al borrar: \(error)")
            }
        }
    }
}
