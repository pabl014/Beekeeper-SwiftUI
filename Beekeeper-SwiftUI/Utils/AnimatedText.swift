//
//  AnimatedText.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 13/04/2025.
//

import SwiftUI

struct AnimatedText: View {
    
    @State private var moveGradient = true
    
    var body: some View {
        
        let screenWidth = UIScreen.main.bounds.size.width
        
        Rectangle()
            .overlay {
                LinearGradient(colors: [.clear, .white, .clear], startPoint: .leading,
                               endPoint: .trailing)
                .frame(width: 60)
                .offset(x: moveGradient ? -screenWidth/2 : screenWidth/2)
            }
            .animation(.linear(duration: 6).repeatForever(autoreverses: false), value:
                moveGradient)
            .mask {
                Text("Beekeeper")
                    .foregroundColor(.black)
                    .font(.system(size: 60, weight: .bold, design: .rounded))
            }
            .onAppear {
                self.moveGradient.toggle()
            }
    }
}

#Preview {
    AnimatedText()
}
