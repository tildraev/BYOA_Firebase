//
//  LoginViewController.swift
//  TravelPix
//
//  Created by Arian Mohajer on 2/22/22.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        if let emailAddress = emailTextField.text, !emailAddress.isEmpty,
           let password = passwordTextField.text, !password.isEmpty {
            
            Auth.auth().signIn(withEmail: emailAddress, password: password) { result, error in
                switch result {
                    
                case .none:
                    let alertController = UIAlertController(title: "No account found", message: "Please check your email and password", preferredStyle: .alert)
                    let confirmAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(confirmAction)
                    self.present(alertController, animated: true, completion: nil)
                case .some(let userDetails):
                    print("Welcome back,", userDetails.user.email!)
                    let storyboard = UIStoryboard(name: "HomePage", bundle: nil)
                    let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController
                    let homePageViewModel = HomePageViewModel(userID: userDetails.user.uid)
                    let homePageViewController = navigationController?.viewControllers[0] as? HomePageViewController
                    homePageViewController?.viewModel = homePageViewModel
                    navigationController?.modalPresentationStyle = .fullScreen
                    self.present(navigationController!, animated: true, completion: nil)
                }
            }
        }
    }
}
