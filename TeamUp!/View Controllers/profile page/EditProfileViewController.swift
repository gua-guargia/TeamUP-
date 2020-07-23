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
    
    var profileInfo = [ProfileInfo]()
    var documentID:String = ""
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //customToolbar.set
        print("\(self.profileInfo)")
        
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
        //self.setUpData()
        /*
        let db = Firestore.firestore()
        db.collection("users").whereField("uid", isEqualTo: CURRENT_USER_UID!).getDocuments() { (querySnapshot, error) in
            self.profileInfo.removeAll()
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
            } else {
                for i in querySnapshot!.documents {
                    let id = i.documentID
                    let lastName = i.get("lastname") as! String
                    let firstName = i.get("firstname") as! String
                    //self.courseText.text = i.get("major") as! String
                    let major = i.get("major") as! String
                    let email = i.get("email") as! String
                    let skills = i.get("skills") as! String
                    let modules_taken = i.get("modules_taken") as! String
                    let name = firstName + " " + lastName
                    self.profileInfo.append(ProfileInfo(name: name, lastName: lastName, firstName: firstName, email: email, modules_taken: modules_taken,skills: skills, major: major))
                    self.documentID = id
                    print("done snapshot, \(firstName), \(lastName)")
                    
                }
                self.setUpData()
            }
        }*/
        
        
    }
    
    private func setUpData() {
        courseText.text = self.profileInfo[0].major
        emailText.text = self.profileInfo[0].email
        skillsText.text = self.profileInfo[0].skills
        modulesText.text = self.profileInfo[0].modules_taken
        lastNameText.text = self.profileInfo[0].lastName
        firstNameText.text = self.profileInfo[0].firstName
        setUpElements()
    }
    
    @objc func handleDone() {
        print("Handle done")
        let error = validateFields()
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
            let db = Firestore.firestore()
            // Add a new document in collection "cities"
            db.collection("users").document(documentID).setData([
                "lastname": lastName,
                "email": email,
                "firstname": firstName,
                "major": major,
                "skills":skills,
                "modules_taken":modules
            ])
        }
    }
    
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
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

extension EditProfileViewController: AddProfileInfoDelegate {
    func addProfileInfo(profileInfo: [ProfileInfo]) {
        self.dismiss(animated: true) {
            self.profileInfo = profileInfo
            self.reloadInputViews()
        }
    }
}
