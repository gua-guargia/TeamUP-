//
//  ModuleCreationViewController.swift
//  TeamUp!
//
//  Created by Alicia Ho on 30/5/20.
//  Copyright © 2020 Alicia Ho. All rights reserved.
//

import UIKit

class ModuleCreationViewController: UIViewController {

    @IBOutlet weak var ModName: UITextField!
    
    @IBOutlet weak var OrganiserName: UITextField!
    
    @IBOutlet weak var ModDescription: UITextField!
    
    @IBOutlet weak var Donebutton: UIButton!
    
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setUpElements()
   }
   
   func setUpElements() {
       //hide the error label
       errorLabel.alpha = 0
       
       //style the elements
       Utilities.styleTextField(ModName)
       
       Utilities.styleTextField(OrganiserName)
       
       Utilities.styleTextField(ModDescription)
       
       Utilities.styleFilledButton(Donebutton)
       
       
   }
}
