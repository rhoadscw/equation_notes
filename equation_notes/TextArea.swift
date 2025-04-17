//
//  TextArea.swift
//  equation_notes
//
//  Created by Rhoads Wilson on 12/04/2025.
//

import Foundation
import SwiftData

//this used to be codable
/*
enum TextType{
    case equation
    case description
}
*/
@Model
class TextArea: Identifiable, Hashable {
    
    var id = UUID()
    
    var type: Int //0 or 1, indicating if text is an equation or not
    var body: String
    var sortOrder: Int
    
    init(id: UUID = UUID(), type: Int, body: String, sortOrder: Int) {
        self.id = id
        self.type = type
        self.body = body
        self.sortOrder = sortOrder
    }
}
