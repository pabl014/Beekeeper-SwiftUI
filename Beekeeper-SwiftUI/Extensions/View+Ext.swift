//
//  View+Ext.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 24/04/2025.
//

import SwiftUI

extension View {
    func cornerRadius(_ radius: CGFloat) -> some View {
        self.clipShape(RoundedRectangle(cornerRadius: radius))
    }
}
