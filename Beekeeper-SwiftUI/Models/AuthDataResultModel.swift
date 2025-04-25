//
//  AuthDataResultModel.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 25/04/2025.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoURL: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoURL = user.photoURL?.absoluteString
    }
}
