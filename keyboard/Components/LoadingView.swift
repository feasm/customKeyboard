//
//  LoadingView.swift
//  keyboard
//
//  Created by Felipe Alexander Da Silva Melo on 02/08/22.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: Color("SecondaryColor")))
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
