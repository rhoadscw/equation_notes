//
//  Note.swift
//  equation_notes
//
//  Created by Rhoads Wilson on 10/04/2025.
//

import Foundation
import SwiftData

//note object. Each individual note is one of these
@Model
class Note: Hashable, Identifiable{
    var id: UUID
    var title: String
    @Relationship(deleteRule: .cascade) var sections = [TextArea]()
    var dateCreated: Date
    
    init(title: String, dateCreated: Date) {
        self.title = title
        //self.sections = sections
        self.dateCreated = dateCreated
        self.id = UUID()
    }
    
}
