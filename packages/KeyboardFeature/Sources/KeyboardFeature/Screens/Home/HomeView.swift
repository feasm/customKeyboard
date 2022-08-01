//
//  HomeView.swift
//  
//
//  Created by Felipe Melo on 26/07/22.
//

import SwiftUI
import Combine

public struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    
    public init() {}
    
    public var body: some View {
        ZStack {
            Color.gray
            
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                    .scaleEffect(2)
                    .animation(.easeIn)
            } else {
                if viewModel.hasErrors {
                    VStack {
                        Text("Something wrong happened, try again later :(")
                        PrimaryButton(text: "Reload") {
                            viewModel.getContent()
                        }
                    }
                } else {
                    VStack {
                        Spacer()
                        
                        HStack {
                            ForEach(viewModel.contentList.content) { content in
                                PrimaryButton(text: content.displayText ?? "") {
                                    //                        print("button tapped!")
                                }
                            }
                        }
                        
                        Spacer()
                        
                        HStack {
                            PrimaryButton(text: "EXIT") {
                                viewModel.getContent()
                            }
                            .padding([.leading], 20)
                            
                            Spacer()
                        }
                    }
                }
            }
        }
        .frame(height: 260)
        .onAppear {
            viewModel.getContent()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .previewLayout(.fixed(width: 300, height: 260))
    }
}
