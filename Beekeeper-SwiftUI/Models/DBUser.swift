//
//  DBUser.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 26/04/2025.
//

import Foundation

struct DBUser: Codable {
    let userId: String
    let email: String?
    let displayName: String?
    let photoURL: String?
    let dateCreated: Date?
    let yardsCount: Int?
    
    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.email = auth.email
        self.displayName = auth.displayName ?? auth.email?.components(separatedBy: "@").first
        self.photoURL = auth.photoURL
        self.dateCreated = Date()
        self.yardsCount = 0
    }
    
    init (userId: String, email: String? = nil, displayName: String? = nil, photoURL: String? = nil, dateCreated: Date? = nil, yardsCount: Int? = nil) {
        self.userId = userId
        self.email = email
        self.displayName = displayName
        self.photoURL = photoURL
        self.dateCreated = Date()
        self.yardsCount = yardsCount
    }
}
