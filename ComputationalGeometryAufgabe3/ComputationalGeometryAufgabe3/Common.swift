//
//  Common.swift
//  ComputationalGeometryAufgabe3
//
//  Created by Julian Wittek on 24.05.19.
//  Copyright © 2019 Julian Wittek. All rights reserved.
//

import Foundation

// > 0 left
// = 0 on
// < 0 right
func ccw(line: Line, point: Point) -> Double {
    return line.start.y * point.x - line.end.y * point.x + line.end.x * point.y - line.start.x * point.y - line.start.y * line.end.x + line.start.x * line.end.y
}

func getEventType(point: Point, line: Line) -> EventType {
    let firstPoint = line.start
    let secondPoint = line.end
    
    if firstPoint.x < secondPoint.x {
        if point == firstPoint {
            return EventType.LeftEndpoint
        } else {
            return EventType.RightEndpoint
        }
    } else if firstPoint.x > secondPoint.x {
        if point == firstPoint {
            return EventType.RightEndpoint
        } else {
            return EventType.LeftEndpoint
        }
    } else {
        fputs("Line is parallel to Y-Axis", stderr)
        exit(-1)
    }
}

func updateSweepLine(tree: AVLTree<Double, Line>, x: Double) -> AVLTree<Double, Line> {
    let updatedTree = AVLTree<Double, Line>()
    
    while tree.size != 0 {
        if let root = tree.root, let node = root.minimum() {
            let line = node.payload
            let newKey = line!.getYForX(x: x)
            tree.delete(key: node.key)
            updatedTree.insert(key: newKey, payload: line)
        }
    }
    
    return updatedTree
}
