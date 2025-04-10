//
//  ContentView.swift
//  equation_notes
//
//  Created by Rhoads Wilson on 10/04/2025.
//

import SwiftUI
import LaTeXSwiftUI

enum TextType: Codable{
    case equation
    case description
}

struct TextArea : Codable, Hashable, Identifiable {
    var id = UUID()
    var type: TextType
    var body: String
}

struct ContentView: View {
    
    @State var title = "Sample"
    @State var description = ""
    //@State var noEquations = 0
    @State var sections = [TextArea]()
    @State private var showingSheet = false
    
    var body: some View {
        NavigationStack{
            List{
                //TextField("Title", text: $title)
                
                TextEditor(text: $description)
                    .frame(minHeight: 50)
                
                ForEach($sections){ $section in
                    
                    if section.type == .description {
                        TextEditor(text: $section.body)
                    }
                    else{
                        TextEditor(text: $section.body)
                        LaTeX(section.body)
                            .font(.title)
                    }
                    
                        
                
                }
                .onDelete(perform: removeSection)
            }
            .navigationTitle($title) //editable title
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                Button("New eqn"){
                    //need the double slash. Shows up and single slash
                    //addEqn(symbol: "$\\Pi$" )
                    showingSheet.toggle()
                }
                .sheet(isPresented: $showingSheet){
                    DrawView(sections: $sections)
                }
                Button("body"){
                    addBody()
                }
                
            }
        }
        
    }
    func addBody(){
        let newSection = TextArea(type: TextType.description, body: "")
        sections.append(newSection)
    }
    func addEqn(symbol: String){
        let newSection = TextArea(type: TextType.equation, body: symbol)
        sections.append(newSection)
    }
    
    func removeSection(at offsets: IndexSet) {
        sections.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
}
