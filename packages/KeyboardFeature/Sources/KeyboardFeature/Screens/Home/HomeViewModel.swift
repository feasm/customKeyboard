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
    
    var keysMessage = CurrentValueSubject<String, Never>("Initial Message")
    
    private var selectedId: String? = nil
    private var selectedIndex = 0
    
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
    
    func didTapButton(id: String?) {
        if let content = contentList.content.first(where: { $0.id == id }) {
            if selectedId != content.id {
                selectedId = content.id
                selectedIndex = 0
            }
            
            let message = content.content?[selectedIndex] ?? ""
            keysMessage.send(message)
            
            selectedIndex = selectedIndex + 1 == content.content?.count ? 0 : selectedIndex + 1
        }
    }
    
}
