//
//  LoginViewController.swift
//  TeamUp!
//
//  Created by apple on 5/26/20.
//  Copyright © 2020 Alicia Ho. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class LoginViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements() {
        //hide the error label
        errorLabel.alpha = 0
        
        //style the elements
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
        
    }



    @IBAction func loginTapped(_ sender: Any) {
        //TODO: validate  Text Field
        
        //create cleaned versions of the text field
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                //couldn't sign in
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }
            else {
                
                let categoryViewController = self.storyboard?.instantiateViewController(identifier: "mainTab") as? UITabBarController
                self.view.window?.rootViewController = categoryViewController
                self.view.window?.makeKeyAndVisible()
                
            }
        }
    }
    
    
}
