//
//  File.swift
//  TeamUp!
//
//  Created by Alicia Ho on 30/5/20.
//  Copyright © 2020 Alicia Ho. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol DocumentSerializable  {
    init?(dictionary:[String:Any])
}


struct Project {
    var Name:String
    var Organiser:String
    var Description:String
    
    var dictionary:[String:Any] {
        return [
            "Name": Name,
            "Organiser" : Organiser,
            "Description" : Description
        ]
    }
    
}

extension Project : DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let Name = dictionary["Name"] as? String,
            let Organiser = dictionary["Organiser"] as? String,
            let Description = dictionary ["Description"] as? String else {return nil}
        
        self.init(Name: Name, Organiser: Organiser, Description: Description)
    }
}
