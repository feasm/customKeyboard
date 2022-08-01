//
//  KeyboardViewController.swift
//  keyboard
//
//  Created by John Peterson on 5/10/22.
//

import UIKit
import SwiftUI
import Combine

class KeyboardViewController: UIInputViewController {
    
    var homeView: HomeView?
    private var cancelBag = [AnyCancellable]()
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         Instantiate and render our SwiftUI RootView
         
         Tip - the built in method `advanceToNextInput` exits our keyboard and takes
         the user to the next
         */
        let view = HomeView()
        setup(with: view)
        homeView = view
        
        homeView?
            .viewModel
            .keysMessage
            .sink(receiveValue: { [weak self] value in
                let currentText = self?.textDocumentProxy.selectedText ?? ""
                self?.textDocumentProxy.setMarkedText(value, selectedRange: NSRange(location: 0, length: currentText.count))
                self?.textDocumentProxy.docume
//                self?.textDocumentProxy.insertText(value)
            })
            .store(in: &cancelBag)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
    }
}

// MARK: - Custom Helpers for rendering SwiftUI (Don't worry about this)

extension KeyboardViewController {
    func setup<Content: View>(with view: Content) {
        self.view.subviews.forEach { $0.removeFromSuperview() }
        let controller = KeyboardHostingController(rootView: view)
        controller.add(to: self)
    }
}

public class KeyboardHostingController<Content: View>: UIHostingController<Content> {
    func add(to controller: KeyboardViewController) {
        controller.addChild(self)
        controller.view.addSubview(view)
        didMove(toParent: controller)
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: controller.view.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: controller.view.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: controller.view.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: controller.view.bottomAnchor).isActive = true
    }
}
