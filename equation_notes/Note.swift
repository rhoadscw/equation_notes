//
//  Note.swift
//  equation_notes
//
//  Created by Rhoads Wilson on 10/04/2025.
//

import Foundation
import SwiftData


enum TextType: Codable{
    case equation
    case description
}

@Model
class TextArea : Hashable, Identifiable {
    var id = UUID()
    var type: TextType
    var body: String
    
    init(id: UUID = UUID(), type: TextType, body: String) {
        self.id = id
        self.type = type
        self.body = body
    }
}

@Model
class Note: Hashable, Identifiable{
    var id: UUID
    var title: String
    var sections: [TextArea]
    var dateCreated: Date
    
    init(title: String, sections: [TextArea], dateCreated: Date) {
        self.title = title
        self.sections = sections
        self.dateCreated = dateCreated
        self.id = UUID()
    }
    
}
