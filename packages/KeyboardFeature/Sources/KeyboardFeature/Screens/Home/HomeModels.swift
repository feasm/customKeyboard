//
//  File.swift
//  
//
//  Created by Felipe Melo on 26/07/22.
//

import Foundation
import RealmSwift

class ContentListModel: Object, Decodable {
    dynamic var content = List<ContentModel>()
    
    func getBy(id: String?) -> ContentModel? {
        return content.first(where: { $0.id == id })
    }
}

class ContentModel: Object, Decodable, Identifiable {
    @objc dynamic var id: String? = ""
    @objc dynamic var displayText: String = ""
    dynamic var content = List<String>()
    
    func getMessage(index: Int) -> String {
        return content[index]
    }
}
