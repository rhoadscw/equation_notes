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
                //Text editor for user to edit their equation
                TextEditor(text: $equation.body)
                //The original plan was to have the LaTeX render in real time, below the TextEditor, but
                //I couldn't get it to render in real time, dispite varied approaches. Instead we have a render button
                /*
                LaTeX(equation.body)
                    .renderingStyle(.wait)
                */
            }
            .toolbar{
                Button("Render"){
                    //render the LaTeX
                    showingRender.toggle()
                }
                .sheet(isPresented: $showingRender){
                    RenderedView(equation: equation.body)
                }
                
                Button("Draw"){
                    //bring up the view that allows the user to draw
                    showingDrawView.toggle()
                }
                .sheet(isPresented: $showingDrawView){
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
