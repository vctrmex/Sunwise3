//
//  ChangePasswordViewController.swift
//  Sunwise
//
//  Created by victor manzanero on 20/01/21.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var userTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func recoberyPassword(_ sender: Any) {
        
        let signUpManager = FirebaseAuthManager()
        guard let email = userTextField.text else {
            return
        }
        
        signUpManager.recoberyPassword(emailAddress: email){ [weak self] (success) in
        var message: String = ""
        if (success){
            message = "Password cambiado correctamente."
        } else {
            message = "Se produjo un error."
        }
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self!.display(alertController: alertController)
            
        
    }
        
    }
}
