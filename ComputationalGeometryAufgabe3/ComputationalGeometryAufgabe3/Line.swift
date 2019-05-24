//
//  Line.swift
//  ComputationalGeometryAufgabe3
//
//  Created by Julian Wittek on 24.05.19.
//  Copyright © 2019 Julian Wittek. All rights reserved.
//

import Foundation

struct Line: Equatable {
    let start, end: Point
    let minX, maxX, minY, maxY: Double
    
    init(start: Point, end: Point) {
        self.start = start
        self.end = end
        
        self.minX = min(start.x, end.x)
        self.maxX = max(start.x, end.x)
        self.minY = min(start.y, end.y)
        self.maxY = max(start.y, end.y)
    }
    
    func isLine() -> Bool {
        return start != end
    }
    
    func isPartOfBoundingBox(line: Line) -> Bool {
        return self.start.isPartOfBoundingBox(line: line) || self.end.isPartOfBoundingBox(line: line)
    }
    
    func intersect(line: Line) -> Bool {
        
        if self.isLine() {
            if line.isLine(){
                let a = ccw(line: self, point: line.start)
                let b = ccw(line: self, point: line.end)
                if a == 0 && b == 0 {
                    return line.isPartOfBoundingBox(line: self)
                } else {
                    let c = ccw(line: line, point: self.start)
                    let d = ccw(line: line, point: self.end)
                    
                    return a * b <= 0 && c * d <= 0
                }
            } else {
                return line.start.isPartOfLine(line: self)
            }
        } else {
            if line.isLine() {
                return self.start.isPartOfLine(line: line)
            } else {
                return self.start == line.start
            }
        }
    }
    
    static func == (lhs: Line, rhs: Line) -> Bool {
        return lhs.start == rhs.start && lhs.end == rhs.end
    }
}
