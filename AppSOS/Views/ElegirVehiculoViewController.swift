//
//  ElegirVehiculoViewController.swift
//  AppSOS
//
//  Created by Erick Chunga on 16/04/26.
//

import UIKit
import CoreData

class ElegirVehiculoViewController: UIViewController {

    @IBOutlet weak var tblVehiculos: UITableView!
    
    var listaVehiculos: [VehiculoEntity] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    weak var delegado: SeleccionVehiculoDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblVehiculos.delegate = self
        tblVehiculos.dataSource = self
        cargarVehiculos()
    }
    
    func cargarVehiculos() {
        let solicitud: NSFetchRequest<VehiculoEntity> = VehiculoEntity.fetchRequest()
        do {
            listaVehiculos = try context.fetch(solicitud)
            tblVehiculos.reloadData()
        } catch {
            print("Error al cargar autos: \(error)")
        }
    }
}

extension ElegirVehiculoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaVehiculos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "autoSosCell", for: indexPath)
        let auto = listaVehiculos[indexPath.row]
        
        celda.textLabel?.text = auto.placa
        celda.detailTextLabel?.text = "\(auto.marca ?? "") \(auto.modelo ?? "")"
        celda.imageView?.image = UIImage(systemName: "car.circle.fill")
        
        return celda
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let autoElegido = listaVehiculos[indexPath.row]
        
        delegado?.vehiculoElegidoParaSOS(autoElegido)
        
        dismiss(animated: true, completion: nil)
    }
}
