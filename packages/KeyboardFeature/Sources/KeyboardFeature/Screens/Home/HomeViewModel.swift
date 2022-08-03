//
//  HomeViewModel.swift
//  
//
//  Created by Felipe Melo on 26/07/22.
//

import Foundation
import Combine
import RealmSwift

final class ContentViewModel: Identifiable {
    let id: String
    let displayText: String
    
    init(contentModel: ContentModel) {
        self.id = contentModel.id ?? ""
        self.displayText = contentModel.displayText.uppercased()
    }
    
}

final class HomeViewModel: ObservableObject {
    
    private let service: ContentService
    private let localStorage: LocalStorage
    
    @Published var isLoading = false
    @Published var isShowingPopup = false
    @Published var hasErrors = false
    @Published var contentViewModels = [ContentViewModel]()
    
    var keysMessage = CurrentValueSubject<String, Never>("Initial Message")
    var onExitTapped = PassthroughSubject<Void, Never>()
    
    var messageList: List<String> {
        contentList
            .content
            .first(where: { $0.id == selectedId })?
            .content ?? List<String>()
    }
    
    private var contentList = ContentListModel()
    private var selectedId: String? = nil
    private var selectedIndex = 0
    
    private var cancelBag = [AnyCancellable]()
    
    init(service: ContentService = ContentService(), localStorage: LocalStorage = LocalStorage()) {
        self.service = service
        self.localStorage = localStorage
    }
    
    func getContent() {
        isLoading = true
        
        if let contentList: ContentListModel = localStorage.get() {
            self.contentViewModels = contentList.content.map({ ContentViewModel(contentModel: $0) })
            self.contentList = contentList
            self.isLoading = false
        } else {
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
                    guard let self = self else { return }
                    self.contentViewModels = contentList.content.map({ ContentViewModel(contentModel: $0) })
                    self.contentList = contentList
                    self.localStorage.save(contentList)
                }
                .store(in: &cancelBag)
        }
    }
    
    func clearLocalStorage() {
        localStorage.clear()
        getContent()
    }
    
    func didTapButton(id: String?) {
        if let content = contentList.content.first(where: { $0.id == id }) {
            if selectedId != content.id {
                selectedId = content.id
                selectedIndex = 0
            }
            
            keysMessage.send(content.getMessage(index: selectedIndex))
            
            selectedIndex = selectedIndex + 1 == content.content.count ? 0 : selectedIndex + 1
        }
    }
    
    func didTapMessageOnList(index: Int) {
        selectedIndex = index
        if let content = contentList.getBy(id: selectedId) {
            keysMessage.send(content.getMessage(index: selectedIndex))
            isShowingPopup = false
        }
    }
    
    func didTapExitButton() {
        onExitTapped.send()
    }
    
    func showPopup(id: String) {
        selectedId = id
        isShowingPopup = true
    }
    
}
