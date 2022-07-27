//
//  HomeView.swift
//  
//
//  Created by Felipe Melo on 26/07/22.
//

import SwiftUI
import Combine
import KeysUI
//import KeysUI

public struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    
    public init() {}
    
    public var body: some View {
        ZStack {
            Color.gray
            
            HStack {
                ForEach(viewModel.contentList.content) { content in
                    PrimaryButton(text: content.displayText ?? "") {
//                        print("button tapped!")
                    }
//                    Button {
//
//                    } label: {
//                        Text(content.displayText ?? "")
//                            .padding()
//                            .overlay(
//                                Rectangle()
//                                    .frame(width: nil,
//                                                  height: 2,
//                                                  alignment: .bottom)
//                                    .foregroundColor(Color.gray),
//                                alignment: .bottom)
//                            .background {
//                                Color.white
//                            }
//
//                    }
//                    .cornerRadius(10)
                }
            }
            .onAppear {
                viewModel.getContent()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
