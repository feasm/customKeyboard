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
    
    @Published var isLoading = false
    @Published var hasErrors = false
    @Published var contentList = ContentListModel()
    
    private var cancelBag = [AnyCancellable]()
    
    init(service: ContentService = ContentService()) {
        self.service = service
    }
    
    func getContent() {
        isLoading = true
        
        service
            .getContent()
            .sink { [weak self] result in
                guard let self = self else { return }
                self.isLoading = false
                
                switch result {
                case .finished:
                    self.hasErrors = false
                case .failure:
                    self.hasErrors = true
                }
            } receiveValue: { [weak self] contentList in
                self?.contentList = contentList
            }
            .store(in: &cancelBag)
    }
    
}
