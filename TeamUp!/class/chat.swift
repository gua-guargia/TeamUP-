//
//  chat.swift
//  TeamUp!
//
//  Created by Alicia Ho on 8/7/20.
//  Copyright © 2020 Alicia Ho. All rights reserved.
//

import Foundation

struct Chat {
   
    var users: [String]
    var dictionary: [String: Any] {
    return ["users": users]
       
    }
}

extension Chat {
    init?(dictionary: [String:Any]) {
        guard let chatUsers = dictionary["users"] as? [String] else {return nil}
        self.init(users: chatUsers)
    }
}
