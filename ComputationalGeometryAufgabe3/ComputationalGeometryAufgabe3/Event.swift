//
//  Event.swift
//  ComputationalGeometryAufgabe3
//
//  Created by Julian Wittek on 24.05.19.
//  Copyright © 2019 Julian Wittek. All rights reserved.
//

import Foundation

struct Event {
    let line: Line?
    let eventType: EventType
    let intersectingLines: (Line, Line)?
}

enum EventType {
    case LeftEndpoint
    case RightEndpoint
    case Intersection
}
