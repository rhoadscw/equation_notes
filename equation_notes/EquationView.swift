//
//  EquationView.swift
//  equation_notes
//
//  Created by Rhoads Wilson on 12/04/2025.
//

import SwiftUI
import LaTeXSwiftUI
import SwiftData

struct EquationView: View {
    
    @Bindable var equation: TextArea
    //@State var equation: TextArea
    //@State var working_equation = equation.body
    
    var body: some View {
        NavigationStack{
            List{
                /*
                TextEditor(text: $equation.body)
                LaTeX(equation.body)
                    .font(.title)
                */
            }
        }
    }
}
/*
#Preview {
    let sampleArea = TextArea(type: .equation, body: "hello")
    EquationView(equation: sampleArea)
        .modelContainer(for: TextArea.self, inMemory: true)
    //EquationView(equation: TextArea(type: .equation, body: "$\\sin$"))
}
*/
