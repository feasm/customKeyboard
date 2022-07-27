//
//  HomeView.swift
//  
//
//  Created by Felipe Melo on 26/07/22.
//

import SwiftUI
import Combine
import KeysUI

public struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    
    public init() {}
    
    public var body: some View {
        ContentListView()
        .onAppear {
            viewModel.getContent()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .previewLayout(.sizeThatFits)
    }
}
