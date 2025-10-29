//
//  ButtonGridView.swift
//  8Queens
//
//  Created by Mike Lewis on 10/29/25.
//

import SwiftUI

struct ButtonGridView: View {
    @Binding var grid: [[ButtonState]]
    var toggleState: (Int, Int) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            let minSide = min(geometry.size.width, geometry.size.height)
            let minGridSide = minSide * 0.9
            ZStack {
                Color(.yellow)
                
                VStack(spacing: 4) {
//                    Text("W: \(geometry.size.width) - H: \(geometry.size.height)")
                    ForEach(0..<8, id: \.self) { row in
                        HStack(spacing: 4) {
                            ForEach(0..<8, id: \.self) { col in
                                MyButton(state: grid[row][col]) {
                                    toggleState(row, col)
                                }
                            }
                        }
                    }
                }
                .frame(width: minGridSide, height: minGridSide)
            }
            .frame(width: minSide, height: minSide)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            .aspectRatio(1, contentMode: .fit)

        }
    }
}

//#Preview {
//    ButtonGridView()
//}
