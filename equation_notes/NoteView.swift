//
//  NoteView.swift
//  equation_notes
//
//  Created by Rhoads Wilson on 10/04/2025.
//

import SwiftUI
import LaTeXSwiftUI

struct NoteView: View {
    
    //@Environment(\.modelContext) var modelContext
    
    //@State var title = "Sample"
    //@State var description = ""
    //@State var noEquations = 0
    @Bindable var note: Note
    //@State var sections = [TextArea]()
    @State private var showingSheet = false
    
    var body: some View {
        NavigationStack{
            List{
                //TextField("Title", text: $title)
                /*
                TextEditor(text: $description)
                    .frame(minHeight: 50)
                */
                ForEach($note.sections){ $section in
                    
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
            .navigationTitle($note.title) //editable title
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                Button("New eqn"){
                    //need the double slash. Shows up and single slash
                    //addEqn(symbol: "$\\Pi$" )
                    showingSheet.toggle()
                }
                .sheet(isPresented: $showingSheet){
                    DrawView(sections: $note.sections)
                }
                Button("body"){
                    addBody()
                }
                
            }
        }
        
    }
    func addBody(){
        let newSection = TextArea(type: TextType.description, body: "")
        note.sections.append(newSection)
    }
    func addEqn(symbol: String){
        let newSection = TextArea(type: TextType.equation, body: symbol)
        note.sections.append(newSection)
    }
    
    func removeSection(at offsets: IndexSet) {
        note.sections.remove(atOffsets: offsets)
    }
}

/*
#Preview {
    NoteView()
}
*/
