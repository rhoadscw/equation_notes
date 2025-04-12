//
//  ContentView.swift
//  equation_notes
//
//  Created by Rhoads Wilson on 10/04/2025.
//

import SwiftUI
import SwiftData

//This is the main screen for the notes app. Where users select individual notes and
//can create new ones
struct ContentView: View {
    
    @Environment(\.modelContext) var modelContext
    @Query(sort:\Note.dateCreated, order: .reverse) var notes: [Note]
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(notes){note in
                    NavigationLink(destination: NoteView(note: note)){
                        Text(note.title)
                    }
                }
                .onDelete(perform: deleteNotes)
            }
            .navigationTitle("Notes")
            .toolbar{
                
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                
                ToolbarItem(placement: .topBarTrailing){
                    Button("add", systemImage: "plus"){
                        let emptyNote = Note(title: "Title", sections: [TextArea](), dateCreated: Date.now)
                        modelContext.insert(emptyNote)
                        //NoteView(note: notes[0])
                        
                    }
                }
            }
        }
    }
    
    //deletes selected notes
    func deleteNotes( at indices: IndexSet){
        for index in indices{
            
            //find note by its index
            let note = notes[index]
            
            //remove note from storage
            modelContext.delete(note)
        }
    }

}

#Preview {
    ContentView()
        //.modelContainer(for: Note.self, inMemory: true) //cleans memory after each use
        .modelContainer(for:Note.self)
}
