//
//  userModel.swift
//  rooms
//
//  Created by Nicolas Fernandez Amorosino on 26/02/2018.
//  Copyright © 2018 Nicolas Amorosino. All rights reserved.
//

import Foundation

class User {
    let userId : String
    let idToken : String
    let fullName : String
    let givenName : String
    let familyName : String
    let email : String
    
    init(id: String, token: String, completeName: String, firstName: String, lastName: String, mail: String) {
        self.userId = id
        self.idToken = token
        self.fullName = completeName
        self.givenName = firstName
        self.familyName = lastName
        self.email = mail
    }
}
