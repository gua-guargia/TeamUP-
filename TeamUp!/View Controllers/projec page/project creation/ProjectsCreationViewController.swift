//
//  ProjectsCreationViewController.swift
//  TeamUp!
//
//  Created by Alicia Ho on 30/5/20.
//  Copyright © 2020 Alicia Ho. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class ProjectsCreationViewController: UIViewController {
    

    var db: Firestore!
    
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var ProjectName: UITextField!
    @IBOutlet weak var ProjectDescription: UITextField!
    @IBOutlet weak var roleNeeded: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        setUpElements()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        
        view.backgroundColor = .gray
        
    }
    
    func setUpElements() {
        //hide the error label
        errorLabel.alpha = 0
        
        //style the elements
        Utilities.styleTextField(ProjectName)
        
        Utilities.styleTextField(ProjectDescription)
        
        Utilities.styleTextField(roleNeeded)
    }
    
    @objc func handleDone() {
        print("Handle done")
        
        let error = validateFields()
        
        if error != nil {
            showError(error!)
        }
            //pass data to fIREBASE
        else {
            var CURRENT_USER_UID: String? {
                if let currentUserUid = Auth.auth().currentUser?.uid {
                    return currentUserUid
                }
                return nil
            }
            //create the cleaned version of the data
            let name = ProjectName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let role = roleNeeded.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let description = ProjectDescription.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let uid = CURRENT_USER_UID ?? ""
            
            let docRef = db.collection("users").document("uid")

            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                        let organiser = document.get("name") as? String ?? "Anoymous"
                        self.db.collection("projects").document(name).setData([
                            "name": name,
                            "description": description,
                            "roleNeeded" : role,
                            "uid" : uid,
                            "organiser":organiser
                        ])
                } else {
                    print("Document does not exist")
                }
            }
            
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        }
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    @objc func handleCancel() {
        print("cancel")
        //self.dismiss(animated: true, completion: nil) //for modal view only
        //for push view controller
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func validateFields() -> String? {
        //check that all fields are filled in
        if ProjectName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || ProjectDescription.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || roleNeeded.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        return nil
    }
}
