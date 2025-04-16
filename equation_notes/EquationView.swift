//
//  EquationView.swift
//  equation_notes
//
//  Created by Rhoads Wilson on 12/04/2025.
//

import SwiftUI
import LaTeXSwiftUI
import SwiftData

struct RenderedView: View{
    
    //@Environment(\.dismiss) var dismiss
    
    var equation: String
    
    var body: some View{
        LaTeX(equation)
            .font(.title)
    }
}

struct EquationView: View {
    
    @Bindable var equation: TextArea
    
    @State private var showingRender = false
    @State private var showingDrawView = false
    
    var body: some View {
        NavigationStack{
            List{
                
                TextEditor(text: $equation.body)
                //Text(equation.body)
                //The original plan was to have the LaTeX render in real time, below the TextEditor, but
                //I couldn't get it to render in rea time, dispite varied approaches. Instead we have a render button
                /*
                LaTeX(equation.body)
                    .renderingStyle(.wait)
                */
            }
            .toolbar{
                Button("Render"){
                    showingRender.toggle()
                }
                .sheet(isPresented: $showingRender){
                    //Text("Hello")
                    RenderedView(equation: equation.body)
                }
                
                Button("Draw"){
                    showingDrawView.toggle()
                }
                .sheet(isPresented: $showingDrawView){
                    //Text("Hello")
                    DrawView(equation: $equation.body)
                }
            }
        }
    }
    
}

/*
#Preview {
    
    EquationView()
        //.modelContainer(for: TextArea.self, inMemory: true)
    //EquationView(equation: TextArea(type: .equation, body: "$\\sin$"))
}
*/
