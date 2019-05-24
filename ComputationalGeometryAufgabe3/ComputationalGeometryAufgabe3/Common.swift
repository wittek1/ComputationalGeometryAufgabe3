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
