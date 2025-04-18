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
    let lineWidth = 7.0
    
    @State private var identificationFailAlert = false
    @State private var identificationSuccessAlert = false
    @State private var identifiedSymbol = ("", "")
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack{
            VStack {
                
                Canvas{ context, size in
                    
                    for line in drawing.showLines{
                        var path = Path()
                        path.addLines(line.points)
                        context.stroke(path, with: .color(.black), lineWidth: lineWidth)
                    }
                    
                }
                .gesture(DragGesture()
                    .onChanged( { value in
                        let point = value.location
                        currLine.points.append(point)
                        drawing.showLines.append(currLine)
                        
                    })
                    .onEnded({ value in
                        drawing.lines.append(currLine)
                        print(drawing.lines.count)
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
                    
                    identifiedSymbol = drawing.identify()
                    if identifiedSymbol.0 != "" {
                        //addSymbol(symbol: drawing.identify())
                        identificationSuccessAlert.toggle()
                        //dismiss()
                    }
                    else{
                        identificationFailAlert.toggle()
                    }
                    //print("Result: \(drawing.identify())")
                    //dismiss()
                }
            }
            .alert("Success", isPresented: $identificationSuccessAlert){
                Button("Accept", role: .cancel){
                    addSymbol(symbol: identifiedSymbol.0)
                    dismiss()
                }
                Button("Cancel", role: .destructive){
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
    
    func clear(){
        drawing.lines = [Line]()
        drawing.showLines = [Line]()
    }
    
    func addSymbol(symbol: String){
        
        var insertOffset = equation.count - 1
        var dollarTracker = 0
        
        while (insertOffset >= 0){
            
            print("round \(insertOffset)")
            print("sum = \(equation.count + insertOffset)")
            let targetIndex = equation.index(equation.startIndex, offsetBy: insertOffset)
            
            print(equation[targetIndex])
            if equation[targetIndex] == "$"{
                dollarTracker += 1
                if dollarTracker == 2{
                    break
                }
            }
            
            
            else if equation[targetIndex] != " "{
                break
            }
            
            insertOffset -= 1
            print(insertOffset)
        }
        
        //correction so symbol is inserted after previous character
        if (equation.count > 0) {insertOffset += 1}
        
        print("got to the end and offset is \(insertOffset)")
        equation.insert(contentsOf: symbol, at: equation.index(equation.startIndex, offsetBy: insertOffset))
    }
}
 
/*
#Preview {
    
    DrawView()
}
*/
