//
//  main.swift
//  ComputationalGeometryAufgabe3
//
//  Created by Julian Wittek on 24.05.19.
//  Copyright © 2019 Julian Wittek. All rights reserved.
//

import Foundation

//Implementieren Sie unter Zuhilfenahme der Funktionalität aus Aufgabe 1 zur Berechnung von Schnittpunkten zwischen Linien einen Sweep Line Algorithmus und vergleichen Sie die erzielten Laufzeiten. Verwenden Sie für die Laufzeitvergleiche neben den Daten aus der ersten Aufgabe. Vergleichen Sie ebenso die Laufzeiten für die Files s_1000_1.dat und s_1000_10.dat (s.u.) .

let startTimer = CFAbsoluteTimeGetCurrent()

let argumentCount = CommandLine.argc
let arguments = CommandLine.arguments

if argumentCount < 2 {
    fputs("Please provide the file path to s_1000_10.dat", stderr)
    exit(-1)
}

let data = String.init(bytes: FileManager.default.contents(atPath: URL(string: arguments[1])!.path)!, encoding: .ascii)!

var lines = [Line]()
var eventQueue = AVLTree<Point ,Event>()

for line in data.components(separatedBy: "\n") {
    if line == "" {
        continue
    }
    
    var coordinates = [Double]()
    for stringCoordinate in line.components(separatedBy: " ") {
        coordinates.append(Double(stringCoordinate)!)
    }
    
    let startX = coordinates[0]
    let startY = coordinates[1]
    let endX = coordinates[2]
    let endY = coordinates[3]
    
    let startPoint = Point(x: startX, y: startY)
    let endPoint = Point(x: endX, y: endY)

    let line = Line(start: startPoint, end: endPoint)
    
    eventQueue.insert(
        key: line.start,
        payload: Event(
            line: line,
            eventType: EventType.LeftEndpoint,
            intersectingLines: nil,
            intersect: nil
        )
    )
    
    eventQueue.insert(
        key: line.end,
        payload: Event(
            line: line,
            eventType: EventType.RightEndpoint,
            intersectingLines: nil,
            intersect: nil
        )
    )
}

var segmentList = AVLTree<KeyPoint, Line>()
var outputList = [Event]()

while eventQueue.size != 0 {
    let node = eventQueue.root!.minimum()!
    let event = node.payload!
    
    if event.eventType == EventType.LeftEndpoint {
        let eventSegment = event.line!
        segmentList.insert(key: eventSegment.key, payload: eventSegment)
        let eventSegmentNode = segmentList.search(key: eventSegment.key, node: segmentList.root)
        
        if let segmentANode = eventSegmentNode?.rightChild {
            if eventSegment.hasIntersect(line: segmentANode.payload!) {
                let intersect = eventSegment.getIntersect(line: segmentANode.payload!)
                let payload = Event(line: nil, eventType: EventType.Intersection, intersectingLines: (eventSegment, segmentANode.payload!), intersect: intersect)
                eventQueue.insert(key: intersect, payload: payload)
            }
        }
        
        if let segmentBNode = eventSegmentNode?.leftChild {
            if eventSegment.hasIntersect(line: segmentBNode.payload!) {
                let intersect = eventSegment.getIntersect(line: segmentBNode.payload!)
                let payload = Event(line: nil, eventType: EventType.Intersection, intersectingLines: (eventSegment, segmentBNode.payload!), intersect: intersect)
                eventQueue.insert(key: intersect, payload: payload)
            }
        }

    } else if event.eventType == EventType.RightEndpoint {
        let eventSegment = event.line!
        let eventSegmentNode = segmentList.search(key: eventSegment.key, node: segmentList.root)
        
        if let segmentANode = eventSegmentNode?.rightChild, let segmentBNode = eventSegmentNode?.leftChild {
            if segmentANode.payload!.hasIntersect(line: segmentBNode.payload!) {
                let intersect = segmentANode.payload!.getIntersect(line: segmentBNode.payload!)
                if eventQueue.search(input: intersect) == nil {
                    let payload = Event(line: nil, eventType: EventType.Intersection, intersectingLines: (segmentANode.payload!, segmentBNode.payload!), intersect: intersect)
                    eventQueue.insert(key: intersect, payload: payload)
                }
            }
        }
        
        segmentList.delete(key: eventSegment.key)
        
    } else {
        outputList.append(event)
        
        let segE1 = event.intersectingLines!.0
        let segE2 = event.intersectingLines!.1
        
        // swap in SL
        segmentList.delete(key: segE1.key)
        segmentList.delete(key: segE2.key)
        segmentList.insert(key: segE2.key, payload: segE1)
        segmentList.insert(key: segE1.key, payload: segE2)
        
        if let segA = segmentList.search(key: segE1.key, node: segmentList.root)?.rightChild?.payload {
            if segA.hasIntersect(line: segE2) {
                let intersect = segA.getIntersect(line: segE2)
                if eventQueue.search(input: intersect) == nil {
                    let payload = Event(line: nil, eventType: EventType.Intersection, intersectingLines: (segA, segE2), intersect: intersect)
                    eventQueue.insert(key: intersect, payload: payload)
                }
            }
        }
        
        if let segB = segmentList.search(key: segE2.key, node: segmentList.root)?.leftChild?.payload {
            if segB.hasIntersect(line: segE1) {
                let intersect = segB.getIntersect(line: segE1)
                if eventQueue.search(input: intersect) == nil {
                    let payload = Event(line: nil, eventType: EventType.Intersection, intersectingLines: (segB, segE1), intersect: intersect)
                    eventQueue.insert(key: intersect, payload: payload)
                }
            }
        }
    }

    eventQueue.delete(key: node.key)
}

let endTimer = CFAbsoluteTimeGetCurrent()

let intersectsFound = "Intersects found: \(outputList.count)\n"
let timePassed = "Time passed: \(endTimer - startTimer)s\n"

let out = intersectsFound + timePassed

print(out)

print(outputList.map( { $0.intersect! } ))
