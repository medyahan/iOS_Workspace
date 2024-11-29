//
//  ViewController.swift
//  UserRegistrationFormWork
//
//  Created by Medya Han on 29.11.2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordAgainTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true
        passwordAgainTextField.isSecureTextEntry = true
    }


    @IBAction func signUpButtonClicked(_ sender: Any) {
        
        if usernameTextField.text?.isEmpty == true || passwordTextField.text?.isEmpty == true || passwordAgainTextField.text?.isEmpty == true {
            makeAlert(titleInput: "Warning", messageInput: "Please fill in all fields")
        }
        else if passwordTextField.text != passwordAgainTextField.text {
            makeAlert(titleInput: "Warning", messageInput: "Passwords do not match")
        }
        else {
            UserDefaults.standard.set(usernameTextField.text, forKey: "username")
            UserDefaults.standard.set(passwordTextField.text, forKey: "password")
            
            makeAlert(titleInput: "Sign Up", messageInput: "Sign Up Successful")
        }
       
    }
    
    func makeAlert(titleInput: String, messageInput: String)
    {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

