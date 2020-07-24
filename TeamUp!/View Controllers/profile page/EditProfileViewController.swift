//
//  EditProfileViewController.swift
//  TeamUp!
//
//  Created by apple on 6/30/20.
//  Copyright © 2020 Alicia Ho. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase
import FirebaseAuth

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var firstNameText: UITextField!
    
    @IBOutlet weak var lastNameText: UITextField!
    
    @IBOutlet weak var courseText: UITextField!
    
    @IBOutlet weak var skillsText: UITextField!
    
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var modulesText: UITextField!
    
    var documentID:String = ""
    var passInfo = ProfileInfo(name: "", lastName: "", firstName: "", email: "", modules_taken: "", skills: "", major: "", uid: "")
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //customToolbar.set
        
        //set the navigation
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        
        view.backgroundColor = .gray
    
        //to get the name information
        var CURRENT_USER_UID: String? {
            if let currentUserUid = Auth.auth().currentUser?.uid {
                return currentUserUid
            }
            return nil
        }
        self.setUpData()
    }
    
    private func setUpData() {
        courseText.text = self.passInfo.major
        emailText.text = self.passInfo.email
        skillsText.text = self.passInfo.skills
        modulesText.text = self.passInfo.modules_taken
        lastNameText.text = self.passInfo.lastName
        firstNameText.text = self.passInfo.firstName
        setUpElements()
    }
    
    @objc func handleDone() {
        print("Handle done")
        let error = validateFields()
        let db = Firestore.firestore()
        if error != nil {
            //there is something wrong with the fields, show error messge
            showError(error!)
        }
        else {
            //create the cleaned version of the data
            let firstName = firstNameText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let major = courseText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let skills = skillsText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let modules = modulesText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                       
            //update the info
            var CURRENT_USER_UID: String? {
                if let currentUserUid = Auth.auth().currentUser?.uid {
                    return currentUserUid
                }
                return nil
            }
            
            db.collection("users").document(CURRENT_USER_UID ?? "").setData([
                        "lastname": lastName,
                        "email": email,
                        "firstname": firstName,
                        "major": major,
                        "skills":skills,
                        "modules_taken":modules, "name": firstName + " " + lastName])
        }
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }

    
    @objc func handleCancel() {
        print("cancel")
        //self.dismiss(animated: true, completion: nil) //for modal view only
        //for push view controller
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    
    func setUpElements() {
        //hide the error label
        
        //errorLabel.alpha = 0
        
        //style the elements
        Utilities.styleTextField(firstNameText)
        
        Utilities.styleTextField(lastNameText)
        
        Utilities.styleTextField(emailText)
        
        Utilities.styleTextField(courseText)
        
        Utilities.styleTextField(skillsText)
        
        Utilities.styleTextField(modulesText)
        
       // Utilities.styleFilledButton(signUpButton)
        
        
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func validateFields() -> String? {
        //check that all fields are filled in
        if firstNameText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || courseText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || skillsText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || modulesText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        
        return nil
    }
    
}
