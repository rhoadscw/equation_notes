//
//  HelpView.swift
//  equation_notes
//
//  Created by Rhoads Wilson on 18/04/2025.
//

import SwiftUI

//A view that instructs the user how to use the app, and describes some of its features

struct HelpView: View {
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack{
                    //Text("Summary")
                    //    .font(.title)
                    //    .frame(maxWidth: .infinity, alignment: .leading)
                    Text("This is a note taking app, where you are able to create many notes, all stored locally on your device. The app uses shape recognition to allow you to draw symbols for equations. \n")
                    
                    Text("Note layout")
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Each note is made up of any combination of these sections: Text body, Equations and images. Each section can feature as many times as you want. Text body sections simply contain text like a normal notes app. Image sections allow you to insert images from your camera roll. Equation sections are for writing equations in LaTeX. To add a new section, click the corresponding button in the toolbar, which will insert a new section at the bottom. Sections can be rearranges by holding a section down and moving it, or using the edit button. \n")
                    
                    Text("Equation Sections")
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Most parts of the app are quite self explanitory, aside from the equation sections. When viewing an individual note, equation sections will show the rendered LaTeX of the underlying equation. To edit, simply press the equation. This will take you to a new page where you can edit the underlying LaTeX. Press 'render' at any point to check the equation is as intended. \n")
                    
                    Text("Character recognition")
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("On the page for editing an equation, you will find a 'draw button. Press this to draw a symbol, then press 'recognize' for it to be identified and inserted at the end of the current equation. Please note the only symbols currently recognized are capital pi, capital sigma and the integration symbol.\n")
                    Text("Bugs")
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Unfortunately the app is currently experiencing a bug related to the LaTeX rendering. You will find that after editing an equation and returning to the note view, your changes don't seem to have taken effect. Your changes have actually taken effect, but the rendering module simply hasn't updated. This seems to be a problem with the swift module being used. Please go back to the home screen and then return to the note for it to update.")
                    Text("Additional notices")
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("You should additionally note that the image recognition makes some assumptions about the way you will draw the identifiable characters. Sigma and the integral symbol are required to be drawn in one motion, without lifting your finger from the screen. It is assumed that pi will be drawn as three separate strokes.")
                }
            }
            .navigationTitle("Help")
        }
    }
}

#Preview {
    HelpView()
}
