//
//  HomeView.swift
//  
//
//  Created by Felipe Melo on 26/07/22.
//

import SwiftUI
import Combine

public struct HomeView: View {
    @ObservedObject var viewModel = HomeViewModel()
    
    public init() {}
    
    public var body: some View {
        ZStack {
            Color.gray
            
            if viewModel.isLoading {
                LoadingView()
            } else {
                if viewModel.hasErrors {
                    emptyScreen
                } else {
                    contentListView
                }
            }
        }
        .frame(height: 260)
        .onAppear {
            viewModel.getContent()
        }
    }
    
    private var emptyScreen: some View {
        VStack {
            Text("Something wrong happened, try again later :(")
            PrimaryButton(text: "Reload") {
                viewModel.getContent()
            }
        }
    }
    
    private var contentListView: some View {
        VStack {
            HStack {
                PrimaryButton(text: "CLEAR CACHE") {
                    viewModel.clearLocalStorage()
                }
                .padding([.leading], 20)
                
                Spacer()
            }.padding([.top], 10)
            
            Spacer()
            
            HStack {
                ForEach(viewModel.contentViewModels) { contentViewModel in
                    PrimaryButton(text: contentViewModel.displayText) {
                        viewModel.didTapButton(id: contentViewModel.id)
                    } longPressGesture: {
                        viewModel.showPopup(id: contentViewModel.id)
                    }

                }
            }
            
            Spacer()
            
            HStack {
                PrimaryButton(text: "EXIT") {
                    viewModel.didTapExitButton()
                }
                .padding([.leading], 20)
                
                Spacer()
            }
            .padding([.bottom], 10)
            .popover(isPresented: $viewModel.isShowingPopup) {
                List {
                    ForEach(0..<viewModel.messageList.count) { index in
                        Button {
                            viewModel.didTapMessageOnList(index: index)
                        } label: {
                            Text(viewModel.messageList[index])
                        }
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .previewLayout(.fixed(width: 300, height: 260))
    }
}
