//
//  PerfilViewController.swift
//  AppSOS
//
//  Created by Erick Chunga on 16/04/26.
//

import UIKit

class PerfilViewController: UIViewController {

    @IBOutlet weak var txtNombres: UITextField!
    @IBOutlet weak var txtApellidos: UITextField!
    @IBOutlet weak var txtCelular: UITextField!
    @IBOutlet weak var btnGuardar: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Mi Perfil"
        btnGuardar.layer.cornerRadius = 10
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ocultarTeclado))
        view.addGestureRecognizer(tap)
        
        cargarDatosGuardados()
    }
    
    @objc func ocultarTeclado() {
        view.endEditing(true)
    }

    @IBAction func btnGuardarTapped(_ sender: UIButton) {
        guard let nombres = txtNombres.text, !nombres.isEmpty,
              let apellidos = txtApellidos.text, !apellidos.isEmpty,
              let celular = txtCelular.text, !celular.isEmpty else {
            mostrarAlerta(titulo: "Error", mensaje: "Llena todos los campos.")
            return
        }
        
        UserDefaults.standard.set(nombres, forKey: "perfilNombres")
        UserDefaults.standard.set(apellidos, forKey: "perfilApellidos")
        UserDefaults.standard.set(celular, forKey: "perfilCelular")
        
        mostrarAlerta(titulo: "¡Éxito!", mensaje: "Datos guardados.")
    }
    
    func cargarDatosGuardados() {
        if let nombres = UserDefaults.standard.string(forKey: "perfilNombres") {
            txtNombres.text = nombres
        }
        if let apellidos = UserDefaults.standard.string(forKey: "perfilApellidos") {
            txtApellidos.text = apellidos
        }
        if let celular = UserDefaults.standard.string(forKey: "perfilCelular") {
            txtCelular.text = celular
        }
    }
    
    func mostrarAlerta(titulo: String, mensaje: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default))
        present(alerta, animated: true)
    }
}
