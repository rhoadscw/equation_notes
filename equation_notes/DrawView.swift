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
    @Binding var sections: [TextArea]
    
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
                        //print(point)
                    })
                    .onEnded({ value in
                        drawing.lines.append(currLine)
                        print(drawing.lines.count)
                        //print(currLine.points.count)
                        //print (currLine.points)
                        //print(drawing.isHorizontalLine(line: currLine))
                        //print(drawing.cornerCount(line: currLine))
                        //print("sigma: \(drawing.sigma(currLine))")
                        //print("integral: \(drawing.integral(currLine))")
                        //print("pi: \(drawing.capPi())")
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
                    addEqn(symbol: drawing.identify())
                    print("pi: \(drawing.capPi())")
                    dismiss()
                }
            }
        }
    }
    
    func clear(){
        drawing.lines = [Line]()
        drawing.showLines = [Line]()
    }
    
    func addEqn(symbol: String){
        let newSection = TextArea(type: TextType.equation, body: symbol)
        sections.append(newSection)
    }
}
/*
#Preview {
    
    DrawView()
}
*/
