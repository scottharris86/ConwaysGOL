//
//  Cell.swift
//  ConwaysGOL
//
//  Created by scott harris on 7/27/20.
//

import Foundation

class Cell {
    private var alive = false
    
    var isAlive: Bool {
        return self.alive
    }
    
    func toggleIsAlive() {
        self.alive.toggle()
    }
    
    func setAlive(_ alive: Bool) {
        self.alive = alive
    }
    
    func copy() -> Cell {
        let copy = Cell()
        if isAlive {
            copy.toggleIsAlive()
        }
        return copy
    }
    
}
