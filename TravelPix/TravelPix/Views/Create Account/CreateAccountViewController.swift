//
//  CreateAccountViewController.swift
//  TravelPix
//
//  Created by Arian Mohajer on 2/22/22.
//

import UIKit
import Firebase

class CreateAccountViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func createAccountButtonTapped(_ sender: Any) {
        if let emailAddress = emailTextField.text, !emailAddress.isEmpty,
           let password = passwordTextField.text, !password.isEmpty,
           let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty {
            if password == confirmPassword {
                Auth.auth().createUser(withEmail: emailAddress, password: confirmPassword) { result, error in
                    switch result {
                        
                    case .none:
                        print("hi")
                    case .some(_):
                        print("bye")
                    }
                }
                self.dismiss(animated: true, completion: nil)
                
            } else {
                //Alert that passwords do not match
                let alertController = UIAlertController(title: "Passwords do not match", message: "Please re-enter your password", preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(confirmAction)
                present(alertController, animated: true, completion: nil)
            }
        }
        
        
        
        //self.dismiss(animated: true, completion: nil)
    }
    @IBAction func textFieldDidEndEditing(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
}
