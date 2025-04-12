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

struct TextArea : Codable, Hashable, Identifiable {
    var id = UUID()
    var type: TextType
    var body: String
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
