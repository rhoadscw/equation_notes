//
//  OCR.swift
//  equation_notes
//
//  Created by Rhoads Wilson on 10/04/2025.
//

import Foundation
import SwiftUI

struct Line{
    var points = [CGPoint]()
}

@Observable
class Drawing{
    
    //will need to request users draw big sigma in one stroke, pi in 3 strokes
    
    var lines = [Line]()
    
    //showLines are what is displayed to user. Allows line to be drawn to screen real time without generating many unnecessary lines in the main array
    var showLines = [Line]()
    
    func addLine( line: Line){
        lines.append(line)
    }
    
    //should add scaling so that images are approx comparable to each other
    
    func isHorizontalLine(line: Line)-> Bool{
        
        //using 30 as maximum amount any point can deviate from
        for point in line.points{
            if ((point.y - line.points[0].y).magnitude > 30) {return false}
        }
        return true
        
        //may need further work to make sure
        
        //perhaps vertical distance from start can be allowed to increase more with greater horizontal distance from the start
    }
    
    func isVerticalLine(line: Line)-> Bool{
        
        for point in line.points{
            if ((point.x - line.points[0].x).magnitude > 30) {return false}
        }
        return true
        
    }
    
    func capPi() -> Bool{
        
        
        //verify there are 3 lines
        //print(lines.count)
        if (!(lines.count == 3)){
            return false
        }
        //print("yep, there's 3 lines")
        
        var topLine = lines[0]
        
        
        //isolate horizontal line
        for i in 0..<3{
            if isHorizontalLine(line: lines[i]){
                topLine = lines[i]
                lines.remove(at: i)
                break
            }
        }
        
        //var topLineLen = topLine.points[0].x - topLine.points[topLine.points.count].x
        
        //confirm that one line was removed
        if (!(lines.count == 2)){
            return false
        }
        
        //confirm remaining two lines are approx vertical
        for i in 0..<2{
            var maxYPoint = lines[i].points[0]
            if !isVerticalLine(line: lines[i]){
                return false
            }
            else{
                for point in lines[i].points{
                    //find max y coord of this vertical segment
                    maxYPoint = maxYPoint.y < point.y ? maxYPoint : point
                }
                
                if ((maxYPoint.y - topLine.points[topLine.points.count - 1].y).magnitude > 20) { return false}
                
                //make sure vertical bars are in the region horizontally of the top bar
                if ( maxYPoint.x > max(topLine.points[0].x, topLine.points[topLine.points.count - 1].x)){ return false}
                if ( maxYPoint.x < min(topLine.points[0].x, topLine.points[topLine.points.count - 1].x)){ return false}
                
            }
        }
            
        
        
        
        return true
    }
    
    //currently not actually used
    func grad( a: CGPoint, b: CGPoint)-> Double{
        //return gradient between two points
        
        return Double((b.y - a.y) / ( b.x - a.x))
        
    }
    
    
    func integral( _ initial_line: Line)-> Bool{
        
        var line = initial_line
        
        //integral should consist of only one line
        
        //all i'm really doing here is getting the stem length atm. Will need to conjure up some other tricks
        
        //if less than 20 points total, we will get index errors
        
        if (line.points.count < 20) {return false}
        
        var ydiff = line.points[10].y - line.points[0].y
        var ydir = ydiff / ydiff.magnitude
        var xdiff = line.points[line.points.count - 1].x - line.points[0].x
        var xdir = xdiff / xdiff.magnitude
        
        //assume drawn from top down
        //if integral was drawn left to right, reverse its order
        if (xdir > 0){
            //reverse order of line array
            line.points.reverse()
        }
        
        ydiff = line.points[10].y - line.points[0].y
        ydir = ydiff / ydiff.magnitude
        xdiff = line.points[line.points.count - 1].x - line.points[0].x
        xdir = xdiff / xdiff.magnitude
        
        var ystart = 0
        var yEnd: Int
        
        //first find bit before it goes down and isolate point where downward movement starts:
        
        if (ydir < 0){
            
            //if y direction starts negative, find point it starts going positive
            
            for i in 1..<(line.points.count/10){
                let new_ydiff = line.points[10*i].y - line.points[10*(i-1)].y
                let new_ydir = new_ydiff != 0 ? new_ydiff / new_ydiff.magnitude : ydir //use previous direction if there isn't any movement in the current set of points.
                
                
                if ((new_ydir - ydir).magnitude > 1 ){
                    ystart = i*10
                    
                    break
                }
                ydir = new_ydir
            }
        }
        
        //then go along until change in direction starts to become rapid ( think gradient > 5?). Record this point
        for i in ystart/10..<(line.points.count/10 - 1){
            let grad = grad(a:line.points[i*10],b:line.points[(i+1)*10])
            
            if (grad < -2){
                //set ystart to point it starts heading down rapidly
                //
                ystart = i*10
                
                break
            }
        }
        yEnd = ystart //this could be temporary. Here to gurantee yEnd is initialized
        
        //measure how long the long region is
        //will also need something in here to show it's appropriately straight
        
        for i in ystart/10..<(line.points.count/10 - 1){
            let grad = grad(a:line.points[(i)*10],b:line.points[(i+1)*10])
            
            if (grad > -1){
                //set ystart to point it starts heading down rapidly
                
                yEnd = i*10
                break
            }
            
        }
        
        //continue along to the left, for not more than 0.5*length of vertical line
        
        let lineLen = line.points[yEnd].y - line.points[ystart].y
        //print(lineLen)
        
        
        var finalSuccess = true
        
        
        //make sure segment after long straight component has ended isn't too large and that it exists as strictly less in terms of x component
        for i in yEnd..<(line.points.count){
            if ((line.points[i].x - line.points[yEnd].x).magnitude > 0.5 * lineLen || (line.points[i].y  - line.points[yEnd].y).magnitude > 0.5 * lineLen) {
                finalSuccess = false
                break
            }
            if (line.points[i].x > line.points[yEnd].x) {
                finalSuccess = false
                break
            }
        }
        
        for i in 0..<ystart{
            if ((line.points[i].x - line.points[ystart].x).magnitude > 0.5 * lineLen || (line.points[i].y  - line.points[ystart].y).magnitude > 0.5 * lineLen) {
                finalSuccess = false
                break
            }
            if (line.points[i].x < line.points[ystart].x) {
                finalSuccess = false
                break
            }
        }
        //print(finalSuccess)
        //print(integralCorners(line: line))

        
        if (finalSuccess && integralCorners(line:line) < 3){ return true}
        return false
    }
    
    func integralCorners(line: Line) -> Int{
        
        var corners = 0
        
        let ydiff = line.points[5].y - line.points[0].y
        var ydir = ydiff / ydiff.magnitude

        
        for i in 1..<(line.points.count/10){
            let new_ydiff = line.points[10*i].y - line.points[10*(i-1)].y
            let new_ydir = new_ydiff != 0 ? new_ydiff / new_ydiff.magnitude : ydir //use previous direction if there isn't any movement in the current set of points.
            
            
            if ((new_ydir - ydir).magnitude > 1 && new_ydir != 0.0){
                corners += 1
            }
            ydir = new_ydir
        }
        
        return corners
    }
    
    func sigma(_ initial_line: Line) -> Bool{
        
        var line = initial_line
        
        if (line.points.count < 10) {return false}
        
        //if drawn from bottom up, reverse order of points, so can be viewed as drawn from top down
        if(line.points[0].y > line.points[line.points.count - 1].y){
            line.points.reverse()
        }
        
        let xdiff = line.points[10].x - line.points[0].x
        let xdir = xdiff / xdiff.magnitude
        
        if (xdir < 0 && cornerCountSigma(line: line) == 3){ return true}
        
        return false
    }
    
    func cornerCountSigma( line: Line)-> Int{
        
        //perhaps we take a current gradient (over say 5 points) Then skip some number, I suppose 5, then take next gradient.
        //will have to find what the critical difference in gradient is
        
        //will try another approach. I think I can just go point by point and look for something crazy. When find something crazy, start new average after that point
        
        //in this case actually, I think I can just look for change in polarity
        
        var corners = 0
        
        //this isn't really a corner count anymore, but lets categorise a sigma as three sharp shanges of x direction
        
        let xdiff = line.points[5].x - line.points[0].x
        var xdir = xdiff / xdiff.magnitude
        //var ydiff = line.points[5].y - line.points[0].y
        //var ydir = ydiff / ydiff.magnitude
        //use y later, for security
        for i in 1..<(line.points.count/10){
            let new_xdiff = line.points[10*i].x - line.points[10*(i-1)].x
            let new_xdir = new_xdiff != 0 ? new_xdiff / new_xdiff.magnitude : xdir //use previous direction if there isn't any movement in the current set of points.
            //print(new_xdir)
            
            if ((new_xdir - xdir).magnitude > 1 && new_xdir != 0.0){
                corners += 1
            }
            xdir = new_xdir
        }
        
        return corners
    }
    
    func identify() -> (String, String){
        
        if (lines.count == 1){
            if sigma(lines[0]){
                return (" \\Sigma ", "Σ")
            }
            if integral(lines[0]){
                return (" \\int ", "∫")
            }
        }
        
        if (capPi()) {return (" \\Pi ", "Π")}
        
        print("no matches")
        
        return ("", "")
    }
    
}



