//
//  CalculatorButtonView.swift
//  Calculator
//
//  Created by sun on 7/3/26.
//

import SwiftUI

struct CalculatorButtonView: View {
    let button: CalculatorButtonType
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(button.title)
                .font(.system(size: 40, weight: .regular))
                .frame(width: 82, height: 82)
                .foregroundColor(button.foregroundColor)
                .background(button.backgroundColor)
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }
}
