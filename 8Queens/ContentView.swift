//
//  ContentView.swift
//  8Queens
//
//  Created by Mike Lewis on 10/29/25.
//

import SwiftUI

struct ContentView: View {
    @State private var grid: [[ButtonState]] = Array(
        repeating: Array(repeating: .off, count: 8), count: 8
    )
    
    @State private var gridArray: [[[ButtonState]]] = Array(
        repeating: Array(repeating: Array(repeating: .on, count: 8), count: 8), count: 4
    )
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .top, spacing: 8) {
                VStack {
                    ButtonGridView(grid: $grid, toggleState: toggleState)
                    
                    Spacer()
                    Button("RESET") {
                        let newGrid = Array(
                            repeating: Array(repeating: ButtonState.off, count: 8), count: 8
                        )
                        grid = newGrid
                    }
                    Spacer()
                }
                .frame(width: geometry.size.width * 0.3, height: geometry.size.height)
                
                ScrollView {
                    LazyVGrid(columns: [GridItem()], spacing: 40) {
                        ForEach(0..<4) { i in
                            ButtonGridView(grid: $gridArray[i], toggleState: { _, _ in })
                        }
                    }
                }
                .frame(width: geometry.size.width * 0.7, height: geometry.size.height)
                .background(.purple)
            }
            .padding()
        }
    }
    
    // MARK: - Left grid (main) Read/Write State
    
    private func toggleState(row: Int, col: Int) {
        var newGrid = grid
        switch newGrid[row][col] {
        case .off:
            newGrid[row][col] = .on
        case .on:
            newGrid[row][col] = .off
        case .disabled:
            break // no change
        }
        grid = newGrid
        updateDisabledButtons()
    }
    
    func updateDisabledButtons() {
        var newGrid = grid
        for row in 0..<8 {
            for col in 0..<8 {
                if newGrid[row][col] != .on {
                    var canSeeOn = false
                    for r in 0..<8 {
                        if r != row {
                            if newGrid[r][col] == .on {
                                canSeeOn = true
                            }
                        }
                    }
                    for c in 0..<8 {
                        if c != col {
                            if newGrid[row][c] == .on {
                                canSeeOn = true
                            }
                        }
                    }
                    for r in 0..<8 {
                        for c in 0..<8 {
                            if r != row || c != col {
                                if abs(r - row) == abs(c - col) {
                                    if newGrid[r][c] == .on {
                                        canSeeOn = true
                                    }
                                }
                            }
                        }
                    }
                    
                    if canSeeOn {
                        newGrid[row][col] = .disabled
                    } else {
                        newGrid[row][col] = .off
                    }
                }
            }
        }
        
        grid = newGrid
    }
    
    func stateAt(row: Int, col: Int) -> ButtonState {
        grid[row][col]
    }
    
    // MARK: - Right grids Read/Write State
    
    private func toggleState(for index: Int, row: Int, col: Int) {
        var newGrid = gridArray[index]
        switch newGrid[row][col] {
        case .off:
            newGrid[row][col] = .on
        case .on:
            newGrid[row][col] = .off
        case .disabled:
            break // no change
        }
        gridArray[index] = newGrid
        updateDisabledButtons(for: index)
    }
    
    private func updateDisabledButtons(for index: Int) {
        var newGrid = gridArray[index]
        for row in 0..<8 {
            for col in 0..<8 {
                if newGrid[row][col] != .on {
                    var canSeeOn = false
                    for r in 0..<8 {
                        if r != row {
                            if newGrid[r][col] == .on {
                                canSeeOn = true
                            }
                        }
                    }
                    for c in 0..<8 {
                        if c != col {
                            if newGrid[row][c] == .on {
                                canSeeOn = true
                            }
                        }
                    }
                    for r in 0..<8 {
                        for c in 0..<8 {
                            if r != row || c != col {
                                if abs(r - row) == abs(c - col) {
                                    if newGrid[r][c] == .on {
                                        canSeeOn = true
                                    }
                                }
                            }
                        }
                    }
                    
                    if canSeeOn {
                        newGrid[row][col] = .disabled
                    } else {
                        newGrid[row][col] = .off
                    }
                }
            }
        }
        
        gridArray[index] = newGrid
    }
}

#Preview {
    ContentView()
}

