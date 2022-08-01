//
//  PrimaryButton.swift
//  keyboard
//
//  Created by Felipe Melo on 27/07/22.
//

import SwiftUI

struct PrimaryButton: View {
    var text: String
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(text)
                .padding()
                .overlay(
                    Rectangle()
                        .frame(width: nil,
                                      height: 2,
                                      alignment: .bottom)
                        .foregroundColor(Color.gray),
                    alignment: .bottom)
                .background {
                    Color.white
                }

        }
        .cornerRadius(10)
    }
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryButton(text: "BANTER") {
            
        }
    }
}
