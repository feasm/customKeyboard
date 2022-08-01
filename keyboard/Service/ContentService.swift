//
//  ContentService.swift
//  
//
//  Created by Felipe Melo on 26/07/22.
//

import Foundation
import Combine

enum NetworkError: Error {
    case badURL
    case internalServerError(Error)
}

final public class ContentService {
    
    public init() {
        
    }
    
    func getContent() -> AnyPublisher<ContentListModel, NetworkError> {
        let subject = PassthroughSubject<ContentListModel, NetworkError>()
        
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
            .decode(type: ContentListModel.self, decoder: JSONDecoder())
            .mapError { error in
                return .internalServerError(error)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}
