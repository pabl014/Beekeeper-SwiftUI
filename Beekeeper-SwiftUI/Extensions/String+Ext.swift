//
//  String+Ext.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 13/04/2025.
//

import Foundation

extension String {
    var isValidEmail: Bool {
        let emailRegex: String = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        let emailPredicate: NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
}
