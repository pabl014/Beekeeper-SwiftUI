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
    let displayName: String?
    let photoURL: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.displayName = user.displayName
        self.photoURL = user.photoURL?.absoluteString
    }
}
