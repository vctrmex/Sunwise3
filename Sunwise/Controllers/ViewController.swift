//
//  ViewController.swift
//  Sunwise
//
//  Created by victor manzanero on 20/01/21.
//

import UIKit

class ViewController: UIViewController {

    
    
    @IBOutlet weak var contactPointTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var recuerdame: UISwitch!
    let defaults = UserDefaults.standard
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        if(defaults.bool(forKey: "ban")){
            
            recuerdame.setOn(true, animated: true)
            contactPointTextField.text = defaults.string(forKey: "username")
            passwordTextField.text = defaults.string(forKey: "pass")
            
        }else{
            
            contactPointTextField.text = ""
            passwordTextField.text = ""
        }
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func login(_ sender: Any) {
        
        let loginManager = FirebaseAuthManager()
        guard let email = contactPointTextField.text, let password = passwordTextField.text else { return }
        loginManager.signIn(email: email, pass: password) {[weak self] (success,result) in
            guard let `self` = self else { return }
            var message: String = ""
            if (success) {
                if(self.recuerdame.isOn){
                    
                    self.defaults.set(email, forKey: "username")
                    self.defaults.set(password, forKey: "pass")
                    self.defaults.set(true,forKey:"ban")
                    
                }else{
                    
                    self.defaults.set(email , forKey: "username")
                    self.defaults.set(password, forKey: "pass")
                    self.defaults.set(false,forKey:"ban")
                }
                self.goToNextVC()
            } else {
                message = "Error en el login."
                let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.display(alertController: alertController)
            }
            
        }
        
    }
    
    
    func goToNextVC(){
        
        performSegue(withIdentifier: "otro", sender: nil)
        
        
    }
    


}

