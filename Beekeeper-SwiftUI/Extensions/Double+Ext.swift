//
//  Double+Ext.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 16/05/2025.
//

import Foundation

extension Double {
    var as2DigitString: String {
        String(format: "%.2f", self)
    }
}
