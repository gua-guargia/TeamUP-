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
    
    @IBOutlet weak var ProjectName: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var ProjectDescription: UITextField!
    @IBOutlet weak var OrganiserName: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let settings = FirestoreSettings()

        Firestore.firestore().settings = settings
        
        db = Firestore.firestore()
        
    }
    
    @IBAction func Donebutton(_ sender: Any) {
        //pass data to fIREBASE
        
        var ref: DocumentReference? = nil
        ref = db.collection("projects").addDocument(data: [
            "Name": ProjectName.text,
            "Description": ProjectDescription.text,
            "Organiser" : OrganiserName.text
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        //dismiss popover
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Trashbutton(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func setUpElements() {
        //hide the error label
        errorLabel.alpha = 0
        
        //style the elements
        Utilities.styleTextField(ProjectName)
        
        Utilities.styleTextField(OrganiserName)
        
        Utilities.styleTextField(ProjectDescription)
        
    }

}
