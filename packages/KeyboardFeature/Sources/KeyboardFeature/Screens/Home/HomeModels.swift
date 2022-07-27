//
//  File.swift
//  
//
//  Created by Felipe Melo on 26/07/22.
//

import Foundation

struct ContentListModel: Decodable {
    var content: [ContentModel] = []
}

struct ContentModel: Decodable, Identifiable {
    let id: String?
    let displayText: String?
    let content: [String]?
}
