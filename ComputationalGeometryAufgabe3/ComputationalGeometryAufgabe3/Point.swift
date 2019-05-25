//
//  Point.swift
//  ComputationalGeometryAufgabe3
//
//  Created by Julian Wittek on 24.05.19.
//  Copyright © 2019 Julian Wittek. All rights reserved.
//

import Foundation

struct Point: Equatable, Comparable {
    let x, y: Double
    
    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    
    func isPartOfBoundingBox(line: Line) -> Bool {
        return self.x >= line.minX && self.x <= line.maxX && self.y >= line.minY && self.y <= line.maxY
    }
    
    func isPartOfLine(line: Line) -> Bool {
        if ccw(line: line, point: self) != 0 {
            return false
        } else {
            return self.isPartOfBoundingBox(line: line)
        }
    }
    
    static func == (lhs: Point, rhs: Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
    
    static func < (lhs: Point, rhs: Point) -> Bool {
        return lhs.x == rhs.x ? lhs.y < rhs.y : lhs.x < rhs.x
    }
}
