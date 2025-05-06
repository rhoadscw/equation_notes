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

//Class encapsulating a user's symbol drawing, along with actions that can be performed on the drawing, mainly OCR
@Observable
class Drawing{
    
    //Array of continuous lines the user draws
    var lines = [Line]()
    
    //showLines are what is displayed to user. Allows line to be drawn to screen real time without generating many unnecessary lines in the main array
    var showLines = [Line]()
    
    
    func addLine( line: Line){
        lines.append(line)
    }
    
    //decides if a line is horizontal
    func isHorizontalLine(line: Line)-> Bool{
        
        let maxDeviation = 30.0
        
        //using 30 as maximum amount any point can deviate from, vertically
        for point in line.points{
            if ((point.y - line.points[0].y).magnitude > maxDeviation) {return false}
        }
        return true
    }
    
    //decides if a line is vertical
    func isVerticalLine(line: Line)-> Bool{
        
        let maxDeviation = 30.0
        
        for point in line.points{
            if ((point.x - line.points[0].x).magnitude > maxDeviation) {return false}
        }
        return true
        
    }
    
    //decides if the user has drawn a capital pi
    func capPi() -> Bool{
        
        //verify user has drawn 3 lines total
        if (!(lines.count == 3)){
            return false
        }
        
        var topLine = lines[0]
        
        //isolate horizontal line (from top of Pi) and set it as topLine
        for i in 0..<3{
            if isHorizontalLine(line: lines[i]){
                topLine = lines[i]
                lines.remove(at: i)
                break
            }
        }
        
        //confirm that one line (topLine) was removed, so two lines remain, which are expected to be vertical
        if (!(lines.count == 2)){
            return false
        }
        
        //confirm remaining two lines are as expected
        for i in 0..<2{
            
            let gapAboveHorizontalLine = 90.0
            let gapBelowHorizontalLine = -30.0
            
            var maxYPoint = lines[i].points[0]
            
            //confirm line is vertical
            if !isVerticalLine(line: lines[i]){
                return false
            }
            else{
                for point in lines[i].points{
                    //find max y coord of this vertical segment
                    maxYPoint = maxYPoint.y < point.y ? maxYPoint : point
                }
                
                //Make sure the top of the vertical line is near the horizontal line
                let separation = maxYPoint.y - topLine.points[topLine.points.count - 1].y
                if (separation > gapAboveHorizontalLine) { return false}
                if (separation < gapBelowHorizontalLine) { return false}
                
                
                //make sure vertical bars are in the region horizontally of the top bar
                if ( maxYPoint.x > max(topLine.points[0].x, topLine.points[topLine.points.count - 1].x)){ return false}
                if ( maxYPoint.x < min(topLine.points[0].x, topLine.points[topLine.points.count - 1].x)){ return false}
                
            }
        }
        
        //if none of the fail conditions have been met, shape is assumed to conform to a Pi
        
        return true
    }
    
    //currently not actually used
    func grad( a: CGPoint, b: CGPoint)-> Double{
        //return gradient between two points
        
        return Double((b.y - a.y) / ( b.x - a.x))
        
    }
    
    //determines if the shape is an integration symbol
    func integral( _ initial_line: Line)-> Bool{
        
        var line = initial_line
        var finalSuccess = true
        let sampleFrequency = 2
        
        //if less than sampleFrequency points total, we may get index errors. This shouldn't be a problem, but we include this condition
        //to prevent crashes
        
        if (line.points.count < sampleFrequency * 2) {return false}
        
        //assume drawn from top down
        //if integral was drawn down up, reverse its order
        if (line.points[line.points.count - 1].y - line.points[0].y < 0){
            line.points.reverse()
        }
        
        //ydiff refers to to the difference in x or y between one point and another later point in the points array
        //ydir captures the direction of change: -1, 1 or 0
        
        let ydiff = line.points[sampleFrequency].y - line.points[0].y
        var ydir = ydiff / ydiff.magnitude
        
        var yStart = 0
        var yEnd: Int
        
        //first find bit before it goes down (the hook at the top) and isolate point where downward movement starts:
        
        if (ydir < 0){
            
            //if y direction starts negative, find point it starts going positive
            //looking at each nth point helps isolate real change and improve runtime.
            for i in 1..<(line.points.count/sampleFrequency){
                let new_ydiff = line.points[sampleFrequency*i].y - line.points[sampleFrequency*(i-1)].y
                let new_ydir = new_ydiff != 0 ? new_ydiff / new_ydiff.magnitude : ydir //use previous direction if there isn't any movement in the current set of points.
                
                //when change in vertical direction is found, set this point as ystart
                if ((new_ydir - ydir).magnitude > 1 ){
                    yStart = i*sampleFrequency
                    
                    break
                }
                ydir = new_ydir
            }
        }
        
        //then go along until change in direction starts to become rapid. Record this point
        for i in yStart/sampleFrequency..<(line.points.count/sampleFrequency - 1){
            let grad = grad(a:line.points[i*sampleFrequency],b:line.points[(i+1)*sampleFrequency])
            
            if (grad < -1){
                //set yStart to point it starts heading down rapidly
                yStart = i*sampleFrequency
                
                break
            }
        }
        yEnd = yStart //this could be temporary. Here to gurantee yEnd is initialized
        
        //measure how long the long region is
        for i in yStart/sampleFrequency..<(line.points.count/sampleFrequency - 1){
            let grad = grad(a:line.points[(i)*sampleFrequency],b:line.points[(i+1)*sampleFrequency])
            
            //print (grad)
            if (grad.magnitude < 1){
                //set yEnd to point the gradient flattens
                
                yEnd = i*sampleFrequency
                break
            }
            
        }
        let lineLen = line.points[yEnd].y - line.points[yStart].y
        let allowableLength = 0.6 //allocable length of head/tail is 0.6* length of vertical component
        
        //continue along to the left, for not more than 0.5*length of vertical line and make sure segment after long straight component has ended isn't too large and that it exists as strictly less in terms of x component of the vertical section
        
        for i in yEnd..<(line.points.count){
            
            //fail if section is too long
            if ((line.points[i].x - line.points[yEnd].x).magnitude > allowableLength * lineLen || (line.points[i].y  - line.points[yEnd].y).magnitude > allowableLength * lineLen) {
                finalSuccess = false
                break
            }
            //fail if x component is greter than the end of the long line i.e. if the tail crosses the vertical component
            if (line.points[i].x > line.points[yEnd].x) {
                finalSuccess = false
                break
            }
        }
        
        //same treatment for the head of the integral (top right component)
        for i in 0..<yStart{
            if ((line.points[i].x - line.points[yStart].x).magnitude > allowableLength * lineLen || (line.points[i].y  - line.points[yStart].y).magnitude > allowableLength * lineLen) {
                finalSuccess = false
                break
            }
            if (line.points[i].x < line.points[yStart].x) {
                finalSuccess = false
                break
            }
        }

        //if not failing conditions found and there are a maximum of 2 corners, success.
        if (finalSuccess && integralCorners(line:line) < 3){ return true}
        return false
    }
    
    
    //count number of changes of y-direction
    func integralCorners(line: Line) -> Int{
        
        var corners = 0
        let pointFrequency = 2
        
        let ydiff = line.points[pointFrequency].y - line.points[0].y
        var ydir = ydiff / ydiff.magnitude

        //check points in groupings of ten for change in direction in y axis
        for i in 1..<(line.points.count/pointFrequency){
            let new_ydiff = line.points[pointFrequency*i].y - line.points[pointFrequency*(i-1)].y
            let new_ydir = new_ydiff != 0 ? new_ydiff / new_ydiff.magnitude : ydir //use previous direction if there isn't any movement in the current set of points.
            
            
            //dir is either -1, 0 or 1. declare a corner when -1 shifts to 1 or vice versa
            if ((new_ydir - ydir).magnitude > 1 && new_ydir != 0.0){
                corners += 1
            }
            ydir = new_ydir
        }
        
        return corners
    }
    
    //decide if shape is a sigma
    func sigma(_ initial_line: Line) -> Bool{
        
        var line = initial_line
        let pointFrequency = 2
        
        //prevention against index error crash
        if (line.points.count < pointFrequency + 1) {return false}
        
        //if drawn from bottom up, reverse order of points, so can be viewed as drawn from top down
        if(line.points[0].y > line.points[line.points.count - 1].y){
            line.points.reverse()
        }
        
        
        //initial change in x direction. Must be positive i.e. right to left
        let xdiff = line.points[pointFrequency].x - line.points[0].x
        //let xdir = xdiff / xdiff.magnitude
        
        //fundamantally, this categorizes sigma as 3 changes of horizontal direction, starting from right to left movement
        let corners = cornerCountSigma(line: line, pointFrequency: pointFrequency)
        if (xdiff < 0 && corners.0 == 3 && corners.1 == true){ return true}
        
        return false
    }
    
    //count number of changes in x-direction
    func cornerCountSigma( line: Line, pointFrequency: Int)-> (Int, Bool){
        
        var corners = 0
        var currCornerPos = 0
        var correctYDir = true
        
        let xdiff = line.points[pointFrequency].x - line.points[0].x
        var xdir = xdiff / xdiff.magnitude

        //count changes in direction
        for i in 1..<(line.points.count/pointFrequency){
            let new_xdiff = line.points[pointFrequency*i].x - line.points[pointFrequency*(i-1)].x
            let new_xdir = new_xdiff != 0 ? new_xdiff / new_xdiff.magnitude : xdir //use previous direction if there isn't any movement in the current set of points.
            
            if ((new_xdir - xdir).magnitude > 1 && new_xdir != 0.0){
                //when a new corner is found, check its y-coord is greater than the previous corner (up is down. This is checking each corner is lower on the screen than the previous one, as required for a sigma.
                if corners > 0{
                    if line.points[i * pointFrequency].y < line.points[currCornerPos * pointFrequency].y {
                        correctYDir = false
                    }
                }
                corners += 1
                currCornerPos = i
            }
            xdir = new_xdir
        }
        
        return (corners, correctYDir)
    }
    
    //remove lines deemed too small to be purposeful
    func noiseClearUp(){
        
        let maxLengthSquared = 400.0
        var newLines = [Line]()
        
        for i in 0..<lines.count{
            var longEnough = false
            
            //it is possible for a line with zero points to be created. Identifiting and removing them prevents index errors
            if lines[i].points.count > 0{
                let startPoint = lines[i].points[0]
                for point in lines[i].points{
                    let diff = pow((point.x - startPoint.x), 2) + pow((point.y - startPoint.y), 2)
                    //if a point is more than 20 units away from the start point, the line is long enough to be considered
                    if diff > maxLengthSquared{
                        longEnough = true
                        break
                    }
                }
            }
            //if a line is not long enough it is removed
            if longEnough{
                newLines.append(lines[i])
                //lines.remove(at: i)
            }
        }
        lines = newLines
    }
    
    
    //runs character recognition on the drawing. Returns the LaTeX of the result, along with its unicode representation
    func identify() -> (String, String){
        
        noiseClearUp()
        
        if (lines.count == 1){
            if sigma(lines[0]){
                return (" \\Sigma ", "Σ")
            }
            if integral(lines[0]){
                return (" \\int ", "∫")
            }
        }
        
        if (capPi()) {return (" \\Pi ", "Π")}
        
        //print("no matches")
        
        return ("", "")
    }
    
}



