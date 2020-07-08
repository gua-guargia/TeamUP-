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
import FirebaseFirestore

class SignUpViewController: UIViewController {

    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var universityTextField: UITextField!
    
    @IBOutlet weak var majorTextField: UITextField!
    
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
        
        Utilities.styleTextField(universityTextField)
        
        Utilities.styleTextField(majorTextField)
        
        Utilities.styleTextField(emailTextField)
        
        Utilities.styleTextField(passwordTextField)
        
        Utilities.styleFilledButton(signUpButton)
        
        
    }
    
    
    //check the text field and validate that the data is correct. If everything is correct, this method returns nil. Otherwise, it returns the error message
    func validateFields() -> String? {
        //check that all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || universityTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || majorTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
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
            //create the cleaned version of the data
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let university = universityTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let major = majorTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                //check for errors
                if err != nil {
                    // there was an error creating the user
                    self.showError("Error creating user")
                }
                else {
                    // user was created successufully, now store the first name and last name
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(data:["firstname":firstName, "lastname":lastName, "university":university,"major":major,"email":email,"uid":result!.user.uid]) { (error) in
                        
                        if error != nil {
                            //show error message
                            self.showError("Error saving user data")//one possible error
                        }
                    }
                    
                    //transition to the home screen
                    self.transitionToCategory()
                }
                
            }
            
           
        }
        
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    
    func transitionToCategory() {
        
        let categoryViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.categoryViewController) as? CategoryViewController
        self.view.window?.rootViewController = categoryViewController
        self.view.window?.makeKeyAndVisible()
    }
}
