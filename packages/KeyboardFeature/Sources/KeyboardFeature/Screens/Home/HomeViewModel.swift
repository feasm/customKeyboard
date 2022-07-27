//
//  HomeViewModel.swift
//  
//
//  Created by Felipe Melo on 26/07/22.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    
    private var service: ContentService
    
    @Published var contentList = ContentListModel()
    
    private var cancelBag = [AnyCancellable]()
    
    init(service: ContentService = ContentService()) {
        self.service = service
    }
    
    func getContent() {
        service
            .getContent()
            .sink { result in
                if case .failure(let error) = result {
                    print(error)
                }
            } receiveValue: { contentList in
                self.contentList = contentList
            }
            .store(in: &cancelBag)
    }
    
}
