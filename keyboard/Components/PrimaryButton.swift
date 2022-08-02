//
//  PrimaryButton.swift
//  keyboard
//
//  Created by Felipe Melo on 27/07/22.
//

import SwiftUI

struct PrimaryButton: View {
    var text: String
    var tapGesture: () -> Void
    var longPressGesture: (() -> Void)?
    
    var body: some View {
        Button(action: {}) {
            Text(text)
                .padding(10)
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
                .foregroundColor(.black)
        }
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 1)
                .onEnded({ _ in
                    longPressGesture?()
                })
        )
        .highPriorityGesture(
            TapGesture()
                .onEnded({ _ in
                    tapGesture()
                })
        )
        .cornerRadius(10)
    }
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryButton(text: "BANTER") {
            
        }
    }
}
