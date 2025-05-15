//
//  LoadingIndicatorView.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 15/05/2025.
//

import SwiftUI

struct LoadingIndicatorView: View {
    var body: some View {
        ProgressView()
            .scaleEffect(1.5)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.ultraThinMaterial)
                    .frame(width: 80, height: 80)
            )
    }
}

#Preview {
    LoadingIndicatorView()
}
