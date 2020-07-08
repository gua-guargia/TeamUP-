//
//  ViewController.swift
//  TeamUp!
//
//  Created by Alicia Ho on 22/5/20.
//  Copyright © 2020 Alicia Ho. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpElements()
    }
    
    func setUpElements() {
        
        Utilities.styleFilledButton(signupButton)
        Utilities.styleHollowButton(loginButton)
        
    }


}

