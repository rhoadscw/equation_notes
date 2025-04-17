//
//  NoteView.swift
//  equation_notes
//
//  Created by Rhoads Wilson on 10/04/2025.
//

import SwiftUI
import LaTeXSwiftUI

struct NoteView: View {

    @Bindable var note: Note

    //@State private var showingSheet = false
    
    var body: some View {
        NavigationStack{
            List{
                //TextField("Title", text: $title)
                /*
                TextEditor(text: $description)
                    .frame(minHeight: 50)
                */
                //Section being identifiable allows this
                ForEach($note.sections.sorted(by: { $0.wrappedValue.sortOrder < $1.wrappedValue.sortOrder })){ $section in
                    
                    if section.type == 0 {
                        TextEditor(text: $section.body)
                    }
                    else{
                        //TextEditor(text: $section.body)
                      
                        NavigationLink(destination: EquationView(equation: section)){
                            LaTeX(section.body)
                                .font(.title)
                                .renderingStyle(.wait)
                        }
                     
                    }
                }
                .onDelete(perform: removeSection)
                .onMove{ indexSet, destination in
                    note.sections.move(fromOffsets: indexSet, toOffset: destination)
                    
                    var sortCounter = 0
                    for section in note.sections{
                        section.sortOrder = sortCounter
                        sortCounter += 1
                        print("counter is: \(sortCounter)")
                    }
                }
            }
            .navigationTitle($note.title) //editable title
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                Button("New eqn"){
                    addEqn()
                    //showingSheet.toggle()
                }
                Button("body"){
                    addBody()
                }
                EditButton()
                
            }
        }
        
    }
    
    
    func addBody(){
        let newSection = TextArea(type: 0, body: "", sortOrder: note.sections.count)
        note.sections.append(newSection)
    }
    func addEqn(){
        let newSection = TextArea(type: 1, body: "$ $", sortOrder: note.sections.count)
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
