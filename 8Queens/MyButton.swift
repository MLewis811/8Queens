//
//  Buttons.swift
//  8Queens
//
//  Created by Mike Lewis on 10/29/25.
//

import SwiftUI

enum ButtonState {
    case on, off, disabled
}

struct MyButton: View {
    let state: ButtonState
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            RoundedRectangle(cornerRadius: 12)
                .fill(backgroundColor)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(style: StrokeStyle(lineWidth: 2))
                )
        }
        .aspectRatio(1, contentMode: .fit)
        .disabled(state == .disabled)
    }
    
    private var backgroundColor: Color {
        switch state {
        case .on:
            return .orange
        case .off:
            return .white
        case .disabled:
            return .gray
        }
    }
}

//#Preview {
//    MyButton()
//}
