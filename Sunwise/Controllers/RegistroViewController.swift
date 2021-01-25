//
//  RegistroViewController.swift
//  Sunwise
//
//  Created by victor manzanero on 20/01/21.
//

import UIKit

class RegistroViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rePasswordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()

        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func Guardar(_ sender: Any) {
        
        if rePasswordTextField.text! == passwordTextField.text! {
        
        let signUpManager = FirebaseAuthManager()
        if let email = emailTextField.text, let password = passwordTextField.text {
            signUpManager.createUser(email: email, password: password) {[weak self] (success) in
            guard let `self` = self else { return }
                
                var message: String = ""
                if (success){
                    message = "El usuario ha sido creado."
                } else {
                    message = "Error la contraseña debe tener minimo 6 caracteres"
                }
                let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.display(alertController: alertController)
            }
        }
        } else {
            
            let message: String = "The password dont match"
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.display(alertController: alertController)
            
        }
        
    }
    
    
    
    

}
