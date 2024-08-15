//
//  HeaderView.swift
//  ConFlow
//
//  Created by Joseph Tham on 7/14/24.
//

import SwiftUI

struct HeaderView: View {
    let title: String
    let background: Color
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0)
                .foregroundColor(background)
            VStack {
                Text(title)
                    .font(.system(size: 50))
                    .foregroundColor(.white)
                    .bold()
            }
            .padding(.top, 80)
        }
        .frame(width: UIScreen.main.bounds.width, height: 350)
        .offset(y: -150)
    }
}

#Preview {
    HeaderView(title: "ConFlow", background: .blue)
}
