//
//  SignUpViewController.swift
//  TeamUp!
//
//  Created by apple on 5/26/20.
//  Copyright © 2020 Alicia Ho. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {

    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    
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
        Utilities.styleTextField(firstNameTextField)
        
        Utilities.styleTextField(lastNameTextField)
        
        Utilities.styleTextField(emailTextField)
        
        Utilities.styleTextField(passwordTextField)
        
        Utilities.styleFilledButton(signUpButton)
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //check the text field and validate that the data is correct. If everything is correct, this method returns nil. Otherwise, it returns the error message
    func validateFields() -> String? {
        
        //check that all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        
        //check if a password is secured (regular expression of password)
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            //password isn't secure enough
            return "Please make sure your password is at least 8 characters, contains a special character and number."
        }
        
        return nil
    }

    @IBAction func signUpTapped(_ sender: Any) {
        //validate the field
        let error = validateFields()
        
        if error != nil {
            //there is something wrong with the fields, show error messge
            showError(error!)
        }
        else {
            //create the user
            Auth.auth().createUser(withEmail: "", password: "") { (result, err) in
                //check for errors
                if err != nil {
                    // there was an error creating the user
                    self.showError("Error creating user")
                }
                else {
                    // user was created successufully, now store the first name and last name
                    let db = Firestore.firestore()
                    db.collection("users")
                }
                
            }
            
            //transition to the home screen
        }
        
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
}
