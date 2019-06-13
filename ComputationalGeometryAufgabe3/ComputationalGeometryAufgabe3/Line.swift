//
//  Line.swift
//  ComputationalGeometryAufgabe3
//
//  Created by Julian Wittek on 24.05.19.
//  Copyright © 2019 Julian Wittek. All rights reserved.
//

import Foundation

struct Line: Equatable, Comparable {
    let start, end: Point
    let minX, maxX, minY, maxY: Double
    var key: KeyPoint
    
    init(start: Point, end: Point) {
        assert(start != end)
        assert(start.x != end.x)
        
        self.minX = min(start.x, end.x)
        self.maxX = max(start.x, end.x)
        self.minY = min(start.y, end.y)
        self.maxY = max(start.y, end.y)
        
        if start.x == minX {
            self.start = start
            self.end = end
            self.key = KeyPoint(x: start.x, y: start.y)
        } else {
            self.start = end
            self.end = start
            self.key = KeyPoint(x: end.x, y: end.y)
        }
        
        
    }
    
    func isLine() -> Bool {
        return start != end
    }
    
    func isPartOfBoundingBox(line: Line) -> Bool {
        return self.start.isPartOfBoundingBox(line: line) || self.end.isPartOfBoundingBox(line: line)
    }
    
    func hasIntersect(line: Line) -> Bool {
        
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
    
    func getIntersect(line: Line) -> Point {
        let dividendX = (line.end.x - line.start.x) * (self.end.x * self.start.y - self.start.x * self.end.y) - (self.end.x - self.start.x) * (line.end.x * line.start.y - line.start.x * line.end.y)
        let dividendY = (self.start.y - self.end.y) * (line.end.x * line.start.y - line.start.x * line.end.y) - (line.start.y - line.end.y) * (self.end.x * self.start.y - self.start.x * self.end.y)
        let divisor = (line.end.y - line.start.y) * (self.end.x - self.start.x) - (self.end.y - self.start.y) * (line.end.x - line.start.x)
            assert(divisor != 0)
        let x = dividendX / divisor
        let y = dividendY / divisor
        
        return Point(x: x, y: y)
    }
    
    func getYForX(x: Double) -> Double {
        return ((self.end.y - self.start.y) / (self.end.x - self.start.x)) * (x - self.start.x) + self.start.y
    }
    
    static func == (lhs: Line, rhs: Line) -> Bool {
        return lhs.start == rhs.start && lhs.end == rhs.end
    }
    
    static func < (lhs: Line, rhs: Line) -> Bool {
        let sortLhs = lhs.key
        let sortRhs = rhs.key
        
        return sortLhs.y == sortRhs.y ? sortLhs.x < sortRhs.x : sortLhs.y < sortRhs.y
    }
}
