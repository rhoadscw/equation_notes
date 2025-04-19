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
                //Display each section, in an order specified by sortOrder, which is editable by the user
                ForEach($note.sections.sorted(by: { $0.wrappedValue.sortOrder < $1.wrappedValue.sortOrder })){ $section in
                    
                    if section.type == 0 {
                        //If it is a text section, give user a text editor to edit it
                        TextEditor(text: $section.body)
                    }
                    
                    else if section.type == 1{
                        //if it is an equation section, show the rendered LaTeX. Click on rendering to edit
                        NavigationLink(destination: EquationView(equation: section)){
                            LaTeX(section.body)
                                .font(.title)
                                .renderingStyle(.wait)
                        }
                     
                    }
                    else{
                        //Otherwise it is an image. Display the image by transforming from data to image
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
                    //reorder sections by dragging
                    note.sections.move(fromOffsets: indexSet, toOffset: destination)
                    
                    var sortCounter = 0
                    //update sortOrder for each section
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
                }
                Button("text"){
                    addBody()
                }
                PhotosPicker(selection: $selectedImage, matching: .images){
                    Label("select an image", systemImage: "photo")
                }
                EditButton()
            }
            .task(id: selectedImage){
                //select image from photo library
                if let image = try? await selectedImage?.loadTransferable(type: Data.self){
                    addPhoto(data: image)
                }
            }
        }
    }
    func addPhoto(data: Data){
        //add selected photo to the note
        let newSection = TextArea(type: 2, body: "", sortOrder: note.sections.count)
        newSection.image = data
        note.sections.append(newSection)
    }
    
    func addBody(){
        //create and insert new, empty text section
        let newSection = TextArea(type: 0, body: "", sortOrder: note.sections.count)
        note.sections.append(newSection)
    }
    func addEqn(){
        //create and insert new, empty equation section
        let newSection = TextArea(type: 1, body: "$ $", sortOrder: note.sections.count)
        note.sections.append(newSection)
    }
    
    func removeSection(at offsets: IndexSet) {
        //remove one or more sections
        note.sections.remove(atOffsets: offsets)
    }
}

/*
#Preview {
    NoteView()
}
*/
