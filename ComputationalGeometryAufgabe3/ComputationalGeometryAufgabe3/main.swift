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
            intersect: nil,
            key: line.start
        )
    )
    
    eventQueue.insert(
        key: line.end,
        payload: Event(
            line: line,
            eventType: EventType.RightEndpoint,
            intersectingLines: nil,
            intersect: nil,
            key: line.end
        )
    )
}

var segmentList = AVLTree<KeyPoint, Line>()
var outputList = [Event]()
var keyReferences = [KeyPoint : KeyPoint]()

while eventQueue.size != 0 {
    let node = eventQueue.root!.minimum()!
    let event = node.payload!
    
    if event.eventType == EventType.LeftEndpoint {
        let eventSegment = event.line!
        segmentList.insert(key: eventSegment.key, payload: eventSegment)
        let eventSegmentNode = segmentList.search(key: eventSegment.key, node: segmentList.root)
        
        if let segmentANode = eventSegmentNode?.leftNeighbor() {
            let segmentA = segmentANode.payload!
            if eventSegment.hasIntersect(line: segmentA) {
                let intersect = eventSegment.getIntersect(line: segmentA)
                let payload = Event(line: nil, eventType: EventType.Intersection, intersectingLines: (segmentA, eventSegment), intersect: intersect, key: intersect)
                eventQueue.insert(key: intersect, payload: payload)
            }
        }
        
        if let segmentBNode = eventSegmentNode?.rightNeighbor() {
            let segmentB = segmentBNode.payload!
            if eventSegment.hasIntersect(line: segmentB) {
                let intersect = eventSegment.getIntersect(line: segmentB)
                let payload = Event(line: nil, eventType: EventType.Intersection, intersectingLines: (eventSegment, segmentB), intersect: intersect, key: intersect)
                eventQueue.insert(key: intersect, payload: payload)
            }
        }

    } else if event.eventType == EventType.RightEndpoint {
        let eventSegment = event.line!
        let currentKey = keyReferences[eventSegment.key] == nil ? eventSegment.key : keyReferences[eventSegment.key]!
        keyReferences.removeValue(forKey: eventSegment.key)

        let eventSegmentNode = segmentList.search(key: currentKey, node: segmentList.root)
        
        if let segmentANode = eventSegmentNode?.leftNeighbor(), let segmentBNode = eventSegmentNode?.rightNeighbor() {
            let segmentA = segmentANode.payload!
            let segmentB = segmentBNode.payload!
            if segmentA.hasIntersect(line: segmentB) {
                let intersect = segmentA.getIntersect(line: segmentB)
                if eventQueue.search(input: intersect) == nil {
                    let payload = Event(line: nil, eventType: EventType.Intersection, intersectingLines: (segmentA, segmentB), intersect: intersect, key: intersect)
                    eventQueue.insert(key: intersect, payload: payload)
                }
            }
        }

        segmentList.delete(key: currentKey)

    } else {
        outputList.append(event)

        let segE1 = event.intersectingLines!.0
        let segE2 = event.intersectingLines!.1

        // swap in SL
        let originalKeySegE1 = segE1.key
        let originalKeySegE2 = segE2.key
        
        if let referenceKeySegE1 = keyReferences[originalKeySegE1] {
            keyReferences.removeValue(forKey: originalKeySegE1)
            segmentList.delete(key: referenceKeySegE1)
            
            if let referenceKeySegE2 = keyReferences[originalKeySegE2] {
                keyReferences.removeValue(forKey: originalKeySegE2)
                segmentList.delete(key: referenceKeySegE2)
                
                keyReferences.updateValue(referenceKeySegE1, forKey: originalKeySegE2)
                segmentList.insert(key: referenceKeySegE1, payload: segE2)
                keyReferences.updateValue(referenceKeySegE2, forKey: originalKeySegE1)
                segmentList.insert(key: referenceKeySegE2, payload: segE1)
                
            } else {
                segmentList.delete(key: originalKeySegE2)
                
                keyReferences.updateValue(referenceKeySegE1, forKey: originalKeySegE2)
                segmentList.insert(key: referenceKeySegE1, payload: segE2)
                keyReferences.updateValue(originalKeySegE2, forKey: originalKeySegE1)
                segmentList.insert(key: originalKeySegE2, payload: segE1)
            }
            
        } else {
            segmentList.delete(key: originalKeySegE1)
            
            if let referenceKeySegE2 = keyReferences[originalKeySegE2] {
                keyReferences.removeValue(forKey: originalKeySegE2)
                segmentList.delete(key: referenceKeySegE2)
                
                keyReferences.updateValue(originalKeySegE1, forKey: originalKeySegE2)
                segmentList.insert(key: originalKeySegE1, payload: segE2)
                keyReferences.updateValue(referenceKeySegE2, forKey: originalKeySegE1)
                segmentList.insert(key: referenceKeySegE2, payload: segE1)
                
            } else {
                segmentList.delete(key: originalKeySegE2)
                
                keyReferences.updateValue(originalKeySegE1, forKey: originalKeySegE2)
                segmentList.insert(key: originalKeySegE1, payload: segE2)
                keyReferences.updateValue(originalKeySegE2, forKey: originalKeySegE1)
                segmentList.insert(key: originalKeySegE2, payload: segE1)
            }
        }
        
        let currentKeySegE1 = keyReferences[originalKeySegE2] == nil ? originalKeySegE2 : keyReferences[originalKeySegE2]!
        let currentKeySegE2 = keyReferences[originalKeySegE1] == nil ? originalKeySegE1 : keyReferences[originalKeySegE1]!

        
        if let segA = segmentList.search(key: currentKeySegE1, node: segmentList.root)?.leftNeighbor()?.payload {
            if segA.hasIntersect(line: segE2) {
                let intersect = segA.getIntersect(line: segE2)
                if eventQueue.search(input: intersect) == nil {
                    let payload = Event(line: nil, eventType: EventType.Intersection, intersectingLines: (segA, segE2), intersect: intersect, key: intersect)
                    eventQueue.insert(key: intersect, payload: payload)
                }
            }
        }

        if let segB = segmentList.search(key: currentKeySegE2, node: segmentList.root)?.rightNeighbor()?.payload {
            if segB.hasIntersect(line: segE1) {
                let intersect = segB.getIntersect(line: segE1)
                if eventQueue.search(input: intersect) == nil {
                    let payload = Event(line: nil, eventType: EventType.Intersection, intersectingLines: (segE1, segB), intersect: intersect, key: intersect)
                    eventQueue.insert(key: intersect, payload: payload)
                }
            }
        }
    }

    eventQueue.delete(key: event.key)
}

let endTimer = CFAbsoluteTimeGetCurrent()

let intersectsFound = "Intersects found: \(outputList.count)\n"
let timePassed = "Time passed: \(endTimer - startTimer)s\n"

let out = intersectsFound + timePassed

print(out)

print(outputList.map( { $0.intersect! } ))
