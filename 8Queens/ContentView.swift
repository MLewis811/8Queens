//
//  ContentView.swift
//  8Queens
//
//  Created by Mike Lewis on 10/29/25.
//

import SwiftUI

struct IdentifiableSolution: Identifiable {
    var id = UUID()
    var solution: [[ButtonState]]
}

struct ContentView: View {
    @State private var grid: [[ButtonState]] = Array(
        repeating: Array(repeating: .off, count: 8), count: 8
    )
    
    @State private var gridArray: [IdentifiableSolution] = []
    
    var body: some View {
        GeometryReader { geometry in
            let leftW = geometry.size.width * 0.6
            let rightW = geometry.size.width - leftW
            
            HStack(alignment: .top, spacing: 8) {
                VStack {
                    ButtonGridView(grid: $grid, toggleState: toggleState)
                    
                    Spacer()
                    HStack{
                        Spacer()
                        Button("RESET") {
                            let newGrid = Array(
                                repeating: Array(repeating: ButtonState.off, count: 8), count: 8
                            )
                            grid = newGrid
                        }
                        Spacer()
                        Button("SAVE") {
                            saveGrid()
                        }
                        Spacer()
                    }
                    Spacer()
                }
                .frame(width: leftW, height: geometry.size.height)
                
                VStack {
                    Text("\(gridArray.count)")
                        .font(.largeTitle)
                        .bold()
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                            ForEach($gridArray, id: \.id) { solvedGrid in
                                ButtonGridView(grid: solvedGrid.solution, toggleState: { _, _ in })
                                    .aspectRatio(1, contentMode: .fit)
//                                    .padding(.trailing)
                            }
                        }
                        .padding(.horizontal, 8)
                    }
                }
                .frame(width: rightW, height: geometry.size.height)
                .background(.purple)
            }
            .padding(.horizontal)
        }
        .ignoresSafeArea()
        .padding(.horizontal)
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
    
    func saveGrid() {
        let newSol = IdentifiableSolution(solution: grid)
        var newGridArray = gridArray
        newGridArray.append(newSol)
        gridArray = newGridArray
    }
}

#Preview {
    ContentView()
}

