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

for line in data.components(separatedBy: "\n") {
    if line == "" {
        continue
    }
    
    var coordinates = [Double]()
    for stringCoordinate in line.components(separatedBy: " ") {
        coordinates.append(Double(stringCoordinate)!)
    }
    
    let line = Line(start: Point(x: coordinates[0], y: coordinates[1]), end: Point(x: coordinates[2], y: coordinates[3]))
    lines.append(line)
}

var intersectCounter = 0
var intersects = "\n"

let lineCount = lines.count



let endTimer = CFAbsoluteTimeGetCurrent()

let intersectsFound = "Intersects found: \(intersectCounter)\n"
let timePassed = "Time passed: \(endTimer - startTimer)s\n"

let out = intersectsFound + timePassed + intersects

print(out)


