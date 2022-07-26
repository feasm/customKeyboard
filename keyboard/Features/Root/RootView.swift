//
//  RootView.swift
//  keyboard
//
//  Created by John Peterson on 5/10/22.
//

import SwiftUI
import Combine

struct ContentList: Decodable {
    var content: [Content] = []
}

struct Content: Decodable, Identifiable {
    let id: String?
    let displayText: String?
    let content: [String]?
}

enum NetworkError: Error {
    case badURL
    case internalServerError(Error)
}

final class KeysService {
    
    func getContent() -> AnyPublisher<ContentList, NetworkError> {
        let subject = PassthroughSubject<ContentList, NetworkError>()
        
        guard let url = URL(string: Constants.baseURL) else {
            subject.send(completion: .failure(.badURL))
            return subject.eraseToAnyPublisher()
        }
        
        return URLSession
            .shared
            .dataTaskPublisher(for: url)
            .tryMap { output -> Data in
                return output.data
            }
            .decode(type: ContentList.self, decoder: JSONDecoder())
            .mapError { error in
                return .internalServerError(error)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}

final class RootViewModel: ObservableObject {
    
    private var service: KeysService
    
    @Published var contentList = ContentList()
    
    private var cancelBag = [AnyCancellable]()
    
    init(service: KeysService = KeysService()) {
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


struct RootView: View {
    @StateObject var viewModel: RootViewModel
    
    var body: some View {
        VStack {
            ForEach(viewModel.contentList.content) { content in
                Text(content.displayText ?? "")
            }
        }
        .onAppear {
            viewModel.getContent()
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(viewModel: RootViewModel())
    }
}
