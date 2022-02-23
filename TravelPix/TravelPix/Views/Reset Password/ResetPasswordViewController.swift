//
//  ResetPasswordViewController.swift
//  TravelPix
//
//  Created by Arian Mohajer on 2/22/22.
//

import UIKit
import Firebase

class ResetPasswordViewController: UIViewController {

    
    @IBOutlet weak var emailAddressTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func sendPasswordResetEmailButtonTapped(_ sender: Any) {
        if let emailAddress = emailAddressTextField.text, !emailAddress.isEmpty {
            
            Auth.auth().sendPasswordReset(withEmail: emailAddress) { error in
                if let error = error {
                    let alertController = UIAlertController(title: "Could not send password reset email", message: error.localizedDescription, preferredStyle: .alert)
                    let confirmAction = UIAlertAction(title: "Go back", style: .default, handler: nil)
                    alertController.addAction(confirmAction)
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    self.navigationController?.popViewController(animated: true)                    
                }
            }
        }
    }
}
