//
//  GamePlayground.swift
//  ConwaysGOL
//
//  Created by scott harris on 7/27/20.
//

import Foundation

class GamePlayground {
    
    var grid = [Cell]()
    
    
    init(style: Int = 0) {
        for _ in 0..<625 {
            self.grid.append(Cell())
        }
        
        switch style {
        case 0:
            return
        case 1:
            generateRandom()
        case 2:
            generateGlider()
        case 3:
            generateSmallExploder()
        case 4:
            generateExploder()
        case 5:
            generateTwoBlinkers()
        default:
            return
        }
    }
    
    func generateRandom() {
        // FOR RANDOM SET UP!!
        for _ in 0...120 {
            let randomIndex = Int.random(in: 0..<625)
            let cell = grid[randomIndex]
            cell.toggleIsAlive()
        }
    }
    func generateSmallExploder() {
        let center = grid.count / 2
        grid[center].toggleIsAlive()
        grid[center - 1].toggleIsAlive()
        grid[center + 1].toggleIsAlive()
        grid[center - 25].toggleIsAlive()
        grid[center + 24].toggleIsAlive()
        grid[center + 26].toggleIsAlive()
        grid[center + 50].toggleIsAlive()
        
    }
    
    func generateExploder() {
        let center = grid.count / 2
        let centerLeft = center + 2
        grid[centerLeft].toggleIsAlive()
        grid[centerLeft - 25].toggleIsAlive()
        grid[centerLeft - 50].toggleIsAlive()
        grid[centerLeft + 25].toggleIsAlive()
        grid[centerLeft + 50].toggleIsAlive()
        let centerRight = center - 2
        grid[centerRight].toggleIsAlive()
        grid[centerRight - 25].toggleIsAlive()
        grid[centerRight - 50].toggleIsAlive()
        grid[centerRight + 25].toggleIsAlive()
        grid[centerRight + 50].toggleIsAlive()
        grid[center - 50].toggleIsAlive()
        grid[center + 50].toggleIsAlive()
        
        
    }
    
    
    
    func generateTwoBlinkers() {
        let indexes = [84,85,86,482,483,484]
        for i in indexes {
            grid[i].toggleIsAlive()
        }
    }
    
    func generateGlider() {
        // FOR A GLIDER!!

        // GET THE CENTER POINT
        let center = grid.count / 2

        // go 3 wide
        for i in center..<(center + 3) {
            grid[i].toggleIsAlive()
        }

        // got to the one above
        grid[(center + 2) - 25].toggleIsAlive()

        // and then that ones left top corner
        grid[(center + 2) - 51].toggleIsAlive()
    }
    
    
    
    func rotateEarth() -> [Cell] {
        let copy = grid.map { $0.copy() }
        
        for (index, item) in copy.enumerated() {
            let answer = decide(for: item, index: index)
            item.setAlive(answer)
        }
        
        var count = 0
        for item in copy {
            if item.isAlive {
                count += 1
                
            }
        }
        
        grid = copy
        return copy
        
    }
    
    func decide(for cell: Cell, index: Int) -> Bool {
        // we need to get indexes for all 8 edges if they exist
        
        // if its a top row it wont have a (left-top-corner, top, right-top-corner)
        
        //if its 0 it wont have a (left-top-corner, top, right-top-corner, previous)
        
        //if its the last one in the first row it wont have a (left-top-corner, top, right-top-corner, next)
        
        //if its in the first column (evenly divisible by 25? PROB NOT) it wont have a (left-top-corner, previous, left-bottom-corner)
        
        //if its in the last column (evenly divisible by 25?) it wont have a (right-top-corner, next, right-bottom-corner)
        
        //if its in the bottom row it wont have a (left-bottom-corner, bottom, right-bottom-corner)
        
        //if its in the bottom row and the first column it wont have a (left-bottom-corner, bottom, right-bottom-corner, previous, top-left-corner)
        
        // if its the last index it wont have a (left-bottom-corner, bottom, right-bottom-corner, next, top-right-corner)
        
        
        // TODO: - can we simplify?
        
        // rules list:
        
        // something like.. all 8 in a list ["left-top-corner", "top", "right-top-corner", "right", "right-bottom-corner", "bottom", "left-bottom-corner", "left"]
        
        var sides = ["left-top-corner", "top", "right-top-corner", "right", "right-bottom-corner", "bottom", "left-bottom-corner", "left"]
        
        // get the row number and column number..
        let row = getRow(for: index)
        let column = getColumn(for: index)
        
        // start removing the ones we dont need
        if row == 0 {
            let needsRemoved = ["left-top-corner", "top", "right-top-corner"]
            let newSides = sides.filter { !needsRemoved.contains($0)}
            sides = newSides
        }
        
        if row == 24 {
            let needsRemoved = ["right-bottom-corner", "bottom", "left-bottom-corner"]
            let newSides = sides.filter { !needsRemoved.contains($0)}
            sides = newSides
        }
        
        if column == 0 {
            let needsRemoved = ["left-top-corner", "left-bottom-corner", "left"]
            let newSides = sides.filter { !needsRemoved.contains($0)}
            sides = newSides
        }
        
        if column == 24 {
            let needsRemoved = ["right-top-corner", "right", "right-bottom-corner"]
            let newSides = sides.filter { !needsRemoved.contains($0)}
            sides = newSides
        }
        
        var indexes: [Int] = []
        for side in sides {
            switch side {
            case "left-top-corner":
                indexes.append(index - 25 - 1)
            case "top":
                indexes.append(index - 25)
            case "right-top-corner":
                indexes.append(index - 25 + 1)
            case "right":
                indexes.append(index + 1)
            case "right-bottom-corner":
                indexes.append(index + 25 + 1)
            case "bottom":
                indexes.append(index + 25)
            case "left-bottom-corner":
                indexes.append(index + 25 - 1)
            case "left":
                indexes.append(index - 1)
            default:
                break
            }
            
        }
        
        var aliveCount = 0
        for index in indexes {
            let check = grid[index]
            if check.isAlive {
                aliveCount += 1
            }
        }
        
        if cell.isAlive == false && aliveCount == 3 {
            return true
        }
        
        if aliveCount > 3 && cell.isAlive {
            return false
        }
        
        if aliveCount >= 2 && cell.isAlive {
            return true
        }
        
        return false
    }
    
    func getRow(for index: Int) -> Int {
        return index / 25
    }
    
    func getColumn(for index: Int) -> Int {
        let ignore = getRow(for: index)
//      its gotta be in this row somewhere
        for i in 0..<25 {
            if ((i + (ignore * 25)) == index) {
              return i
            }
        }
        
        return 0
    }
    
}
