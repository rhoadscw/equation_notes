//
//  NoteView.swift
//  equation_notes
//
//  Created by Rhoads Wilson on 10/04/2025.
//

import SwiftUI
import LaTeXSwiftUI
import PhotosUI

struct NoteView: View {

    @Bindable var note: Note
    @State var selectedImage: PhotosPickerItem?

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
                    else if section.type == 1{
                        //TextEditor(text: $section.body)
                      
                        NavigationLink(destination: EquationView(equation: section)){
                            LaTeX(section.body)
                                .font(.title)
                                .renderingStyle(.wait)
                        }
                     
                    }
                    else{
                        if let imageData = section.image,
                           let presentedImage = UIImage(data: imageData){
                               Image(uiImage: presentedImage)
                                .resizable()
                                .scaledToFit()
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
                
                Button("eqn"){
                    addEqn()
                    //showingSheet.toggle()
                }
                Button("text"){
                    addBody()
                }
                EditButton()
                
                
                PhotosPicker(selection: $selectedImage, matching: .images){
                    Label("select an image", systemImage: "photo")
                }
                
                
                
            }
            .task(id: selectedImage){
                if let image = try? await selectedImage?.loadTransferable(type: Data.self){
                    addPhoto(data: image)
                }
            }
        }
        
    }
    func addPhoto(data: Data){
        let newSection = TextArea(type: 2, body: "", sortOrder: note.sections.count)
        newSection.image = data
        note.sections.append(newSection)
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
