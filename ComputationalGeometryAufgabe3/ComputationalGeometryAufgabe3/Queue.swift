//
//  Queue.swift
//  ComputationalGeometryAufgabe3
//
//  Created by Julian Wittek on 24.05.19.
//  Copyright © 2019 Julian Wittek. All rights reserved.
//

import Foundation

struct Queue<T : Comparable> {
    var list = [T]()
    
    mutating func enqueue(_ element: T) {
        list.append(element)
    }
    
    mutating func push(_ element: T) {
        list.insert(element, at: 0)
    }
    
    mutating func dequeue() -> T? {
        if !list.isEmpty {
            return list.removeFirst()
        } else {
            return nil
        }
    }
    
    mutating func sort() {
        list.sort()
    }
    
    func peek() -> T? {
        if !list.isEmpty {
            return list[0]
        } else {
            return nil
        }
    }
    
    var isEmpty: Bool {
        return list.isEmpty
    }
}
