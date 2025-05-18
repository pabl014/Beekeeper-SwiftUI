//
//  Date+Ext.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 16/05/2025.
//

import Foundation

extension Date {
    var asShortDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: self)
    }
}
