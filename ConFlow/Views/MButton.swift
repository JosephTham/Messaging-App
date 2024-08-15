//
//  MButton.swift
//  ConFlow
//
//  Created by Joseph Tham on 7/15/24.
//

import SwiftUI

struct MButton: View {
    let title: String
    let background: Color
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(background)
                Text(title)
                    .foregroundColor(.white)
                    .bold()
            }
        }
        .padding()
    }
}

#Preview {
    MButton(title: "Value", background: .red) {
        
    }
}
