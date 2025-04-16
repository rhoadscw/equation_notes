//
//  DrawView.swift
//  equation_notes
//
//  Created by Rhoads Wilson on 10/04/2025.
//

import SwiftUI

struct DrawView: View {
    
    @State var drawing = Drawing()
    @State private var currLine = Line()
    //@Binding var sections: [TextArea]
    @Binding var equation: String
    @State var test = " "
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack{
            VStack {
                
                Canvas{ context, size in
                    
                    for line in drawing.showLines{
                        var path = Path()
                        path.addLines(line.points)
                        context.stroke(path, with: .color(line.colour), lineWidth: line.width)
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
                    addSymbol(symbol: drawing.identify())
                    //print("Result: \(drawing.identify())")
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
        //let newSection = TextArea(type: 1, body: symbol)
        var insertOffset = equation.count - 1
        var dollarTracker = 0
        
        //let targetOffset = equation.count - (insertOffset - 1)
        while (insertOffset >= 0){
            
            print("round \(insertOffset)")
            print("sum = \(equation.count + insertOffset)")
            let targetIndex = equation.index(equation.startIndex, offsetBy: insertOffset)
            //print(targetIndex)
            //print(equation[targetIndex])
            
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
        
        //var insertIndex = equation.count - 1
        print("got to the end and offset is \(insertOffset)")
        equation.insert(contentsOf: symbol, at: equation.index(equation.startIndex, offsetBy: insertOffset))
        //equation.append(symbol)
        //test.insert(contentsOf: symbol, at: test.endIndex)
    }
    
}
 
/*
#Preview {
    
    DrawView()
}
*/
