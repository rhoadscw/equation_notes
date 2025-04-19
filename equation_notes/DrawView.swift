//
//  DrawView.swift
//  equation_notes
//
//  Created by Rhoads Wilson on 10/04/2025.
//

import SwiftUI
import LaTeXSwiftUI

struct DrawView: View {
    
    @State var drawing = Drawing()
    @State private var currLine = Line()
    @Binding var equation: String
    
    //displayed line width
    let lineWidth = 7.0
    
    @State private var identificationFailAlert = false
    @State private var identificationSuccessAlert = false
    @State private var identifiedSymbol = ("", "")
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack{
            VStack {
                
                //present the drawing
                Canvas{ context, size in
                    
                    for line in drawing.showLines{
                        var path = Path()
                        path.addLines(line.points)
                        context.stroke(path, with: .color(.black), lineWidth: lineWidth)
                    }
                    
                }
                .gesture(DragGesture()
                    .onChanged( { value in
                        //add point to the line when user draws. Also add whole line to showLines, which is what the user sees
                        let point = value.location
                        currLine.points.append(point)
                        drawing.showLines.append(currLine)
                        
                    })
                    .onEnded({ value in
                        //when user finishes gesture, add the recorded line to the drawing object
                        drawing.lines.append(currLine)
                        currLine = Line(points: [])
                        
                    })
                )
            }
            .frame(minWidth: 200, minHeight: 300)
            .toolbar{
                Button("Clear"){
                    clear()
                }
                Button("identify"){
                    //press to identify the shape
                    identifiedSymbol = drawing.identify()
                    if identifiedSymbol.0 != "" {
                        //if there is a symbol identified, toggle alert
                        identificationSuccessAlert.toggle()
                    }
                    else{
                        //if no symbol identified, toggle other alert
                        identificationFailAlert.toggle()
                    }
                }
            }
            .alert("Success", isPresented: $identificationSuccessAlert){
                Button("Accept", role: .cancel){
                    //if user accepts, add symbol to the note and dismiss drawView
                    addSymbol(symbol: identifiedSymbol.0)
                    dismiss()
                }
                Button("Cancel", role: .destructive){
                    //if user cancels, clear their drawing
                    clear()
                }
            } message:{
                HStack{
                    Text("Shape identified as: \(identifiedSymbol.1)")
                }
            }
            .alert("Unable to identify drawing", isPresented: $identificationFailAlert){
                Button("Retry", role: .destructive){
                    clear()
                }
                Button("Ok", role: .cancel){
                    dismiss()
                }
            }
        }
    }
    
    //reset the drawing
    func clear(){
        drawing.lines = [Line]()
        drawing.showLines = [Line]()
    }
    
    //add a symbol to the equation string
    func addSymbol(symbol: String){
        
        var insertOffset = equation.count - 1
        var dollarTracker = 0
        
        //Intention is to insert the symbol just before the final dollar
        while (insertOffset >= 0){
            
            //index to insert character at
            let targetIndex = equation.index(equation.startIndex, offsetBy: insertOffset)
            
            //count number of dollars. If a second dollar is encountered, don't go further back
            if equation[targetIndex] == "$"{
                dollarTracker += 1
                if dollarTracker == 2{
                    break
                }
            }
            
            //if encounter a character that isn't space or dollar, stop going back. Don't want to insert symbol in the middle of an equation
            else if equation[targetIndex] != " "{
                break
            }
            
            insertOffset -= 1        }
        
        //correction so symbol is inserted after previous character
        if (equation.count > 0) {insertOffset += 1}
        
        equation.insert(contentsOf: symbol, at: equation.index(equation.startIndex, offsetBy: insertOffset))
    }
}
 
/*
#Preview {
    
    DrawView()
}
*/
