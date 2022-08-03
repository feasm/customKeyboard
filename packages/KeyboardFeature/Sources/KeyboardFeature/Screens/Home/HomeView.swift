//
//  HomeView.swift
//  
//
//  Created by Felipe Melo on 26/07/22.
//

import SwiftUI
import Combine

struct ScaleEffect: GeometryEffect {
    func effectValue(size: CGSize) -> ProjectionTransform {
        return ProjectionTransform(CGAffineTransform(scaleX: 2, y: 2))
    }
}

public struct HomeView: View {
    @ObservedObject var viewModel = HomeViewModel()
    @State private var shouldAnimateLoadingView = false
    @State private var shouldAnimateEmptyView = false
    @State private var shouldAnimateContentView = false
    
    public init() {}
    
    public var body: some View {
        ZStack {
            Color("PrimaryColor")
            
            if viewModel.isLoading {
                LoadingView()
                    .scaleEffect(shouldAnimateLoadingView ? 2 : 0.5)
                    .offset(x: 0, y: shouldAnimateLoadingView ? 0 : 20)
                    .onAppear {
                        withAnimation {
                            shouldAnimateLoadingView.toggle()
                        }
                    }
                    .onDisappear {
                        withAnimation {
                            shouldAnimateLoadingView.toggle()
                        }
                    }
            } else {
                if viewModel.hasErrors {
                    emptyScreen
                        .scaleEffect(shouldAnimateEmptyView ? 1 : 0)
                        .opacity(shouldAnimateEmptyView ? 1 : 0)
                        .onAppear {
                            withAnimation {
                                shouldAnimateEmptyView.toggle()
                            }
                        }
                        .onDisappear {
                            shouldAnimateEmptyView.toggle()
                        }
                } else {
                    contentListView
                        .opacity(shouldAnimateContentView ? 1 : 0)
                        .offset(x: shouldAnimateContentView ? 0 : 200, y: 0)
                        .onAppear {
                            withAnimation {
                                shouldAnimateContentView.toggle()
                            }
                        }
                        .onDisappear {
                            withAnimation {
                                shouldAnimateContentView.toggle()
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
                                .foregroundColor(Color("FontColor"))
                        }.listRowBackground(Color("SecondaryColor"))
                    }
                    .listRowBackground(Color("SecondaryColor"))
                }
                .onAppear {
                    UITableView.appearance().backgroundColor = UIColor(named: "PrimaryColor")
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: 300, height: 260))
    }
}
