//
//  File.swift
//  
//
//  Created by Felipe Melo on 26/07/22.
//

import Foundation

struct ContentListModel: Decodable {
    var content: [ContentModel] = []
    
    func getBy(id: String?) -> ContentModel? {
        return content.first(where: { $0.id == id })
    }
}

struct ContentModel: Decodable, Identifiable {
    let id: String?
    let displayText: String?
    let content: [String]?
    
    func getMessage(index: Int) -> String {
        return content?[index] ?? ""
    }
}
