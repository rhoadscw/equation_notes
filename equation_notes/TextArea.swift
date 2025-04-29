//
//  TextArea.swift
//  equation_notes
//
//  Created by Rhoads Wilson on 12/04/2025.
//

import Foundation
import SwiftData

@Model
class TextArea: Identifiable, Hashable {
    
    //Notes are made up of an array or TextAreas. They contain text or an image and indicate how they should be presented
    
    var id = UUID()
    
    var type: Int //0, 1 or 2, indicating if text is an equation, text or a picture
    var body: String
    var sortOrder: Int
    var image: Data?
    
    init(id: UUID = UUID(), type: Int, body: String, sortOrder: Int) {
        self.id = id
        self.type = type
        self.body = body
        self.sortOrder = sortOrder
    }
}
