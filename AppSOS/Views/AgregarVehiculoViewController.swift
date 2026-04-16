//
//  AgregarVehiculoViewController.swift
//  AppSOS
//
//  Created by Erick Chunga on 12/04/26.
//

import UIKit
internal import CoreData

class AgregarVehiculoViewController: UIViewController {

    @IBOutlet weak var scTransmision: UISegmentedControl!
    @IBOutlet weak var txtPlaca: UITextField!
    @IBOutlet weak var txtMarca: UITextField!
    @IBOutlet weak var txtModelo: UITextField!
    @IBOutlet weak var txtAnio: UITextField!
    @IBOutlet weak var txtColor: UITextField!
    @IBOutlet weak var txtVin: UITextField!
    
    @IBOutlet weak var btnTipoVehiculo: UIButton!
    @IBOutlet weak var btnTipoCombustible: UIButton!
    
    @IBOutlet weak var btnGuardar: UIButton!
    
    var vehiculoAEditar: VehiculoEntity?
    
    var tipoVehiculoSeleccionado: String = ""
    var tipoCombustibleSeleccionado: String = ""
        
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        override func viewDidLoad() {
            super.viewDidLoad()
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(ocultarTeclado))
            view.addGestureRecognizer(tap)
            
            btnGuardar.layer.cornerRadius = 10
            
            configurarMenuTipoVehiculo()
            configurarMenuTipoCombustible()
            
            if let vehiculo = vehiculoAEditar {
                title = "Editar Vehículo"
                btnGuardar.setTitle("ACTUALIZAR DATOS", for: .normal)
                txtPlaca.text = vehiculo.placa
                txtMarca.text = vehiculo.marca
                tipoVehiculoSeleccionado = vehiculo.tipoVehiculo ?? ""
                btnTipoVehiculo.setTitle(tipoVehiculoSeleccionado, for: .normal)
            }
        }
        
        @objc func ocultarTeclado() {
            view.endEditing(true)
        }

        func configurarMenuTipoVehiculo() {
            let opciones = ["Sedán", "Hatchback", "SUV", "Pick-up", "Minivan", "Motocicleta"]
            var acciones: [UIAction] = []
            for opcion in opciones {
                let accion = UIAction(title: opcion, image: UIImage(systemName: "car.fill")) { _ in
                    self.tipoVehiculoSeleccionado = opcion
                    self.btnTipoVehiculo.setTitle(opcion, for: .normal)
                }
                acciones.append(accion)
            }
            btnTipoVehiculo.menu = UIMenu(title: "Tipo de Vehículo", children: acciones)
            btnTipoVehiculo.showsMenuAsPrimaryAction = true
        }
        
        func configurarMenuTipoCombustible() {
            let opciones = ["Gasolina 90", "Gasolina 95", "Gasolina 97", "Diésel B5", "GNV", "GLP", "Híbrido", "Eléctrico"]
            var acciones: [UIAction] = []
            for opcion in opciones {
                let accion = UIAction(title: opcion, image: UIImage(systemName: "fuelpump.fill")) { _ in
                    self.tipoCombustibleSeleccionado = opcion
                    self.btnTipoCombustible.setTitle(opcion, for: .normal)
                }
                acciones.append(accion)
            }
            btnTipoCombustible.menu = UIMenu(title: "Combustible", children: acciones)
            btnTipoCombustible.showsMenuAsPrimaryAction = true
        }

        @IBAction func btnGuardarTapped(_ sender: UIButton) {
            guard let placa = txtPlaca.text, !placa.isEmpty,
                  let marca = txtMarca.text, !marca.isEmpty,
                  let modelo = txtModelo.text, !modelo.isEmpty,
                  let anioStr = txtAnio.text, let anio = Int16(anioStr),
                  let color = txtColor.text, !color.isEmpty,
                  let vin = txtVin.text, !vin.isEmpty else {
                print("Faltan campos de texto.")
                return
            }
            
            if tipoVehiculoSeleccionado.isEmpty || tipoCombustibleSeleccionado.isEmpty {
                print("Faltan menús desplegables.")
                return
            }

            
            let indiceSeleccionado = scTransmision.selectedSegmentIndex
            let transmision = scTransmision.titleForSegment(at: indiceSeleccionado) ?? "No definido"

            let nuevo = VehiculoEntity(context: self.context)
            nuevo.placa = placa.uppercased()
            nuevo.marca = marca
            nuevo.modelo = modelo
            nuevo.anio = Int64(anio)
            nuevo.color = color
            nuevo.vin = vin.uppercased()
            nuevo.tipoVehiculo = tipoVehiculoSeleccionado
            nuevo.tipoCombustible = tipoCombustibleSeleccionado
            nuevo.transmision = transmision
            
            do {
                try context.save()
                print("Guardado con éxito: \(transmision)")
                self.navigationController?.popViewController(animated: true)
            } catch {
                print("Error al guardar: \(error)")
            }
        }
    }
