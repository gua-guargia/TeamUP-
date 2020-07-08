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
    var Role: String
    
    var dictionary:[String:Any] {
        return [
            "Name": Name,
            "Organiser" : Organiser,
            "Description" : Description,
            "Role": Role
        ]
    }
    
}

struct Competition {
    var Name:String
    var Organiser:String
    var Description:String
    var WebLink: String
    
    var dictionary:[String:Any] {
        return [
            "Name": Name,
            "Organiser" : Organiser,
            "Description" : Description,
            "WebLink": WebLink
        ]
    }
    
}

struct ModulesStruct : Identifiable{
    var id:String
    var name:String
    var code:String
    var teammateNumber:String
}

struct ProfileInfo{
    var name:String
    var lastName:String
    var firstName:String
    var email:String
    var modules_taken:String
    var skills:String
    var major:String
}

extension Project : DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let Name = dictionary["Name"] as? String,
            let Organiser = dictionary["Organiser"] as? String,
            let Description = dictionary ["Description"] as? String,
            let Role = dictionary["role"] as? String else {return nil}
        
        
        self.init(Name: Name, Organiser: Organiser, Description: Description, Role: Role)
    }
}


extension Competition : DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let Name = dictionary["Name"] as? String,
            let Organiser = dictionary["Organiser"] as? String,
            let Description = dictionary ["Description"] as? String,
            let WebLink = dictionary["WebLink"] as? String else {return nil}
        
        
        self.init(Name: Name, Organiser: Organiser, Description: Description, WebLink: WebLink)
    }
}
