//
//  CalculatorButton.swift
//  CalculatorTesting
//
//  Created by sun on 7/3/26.
//

import SwiftUI

enum CalculatorButtonType: Hashable {
    case digit(Int)
    case decimal
    case equals

    case add
    case subtract
    case multiply
    case divide

    case percent
    case plusMinus
    case clear
    case backspace

    var title: String {
        switch self {
        case .digit(let number):
            return "\(number)"
        case .decimal:
            return "."
        case .equals:
            return "="
        case .add:
            return "+"
        case .subtract:
            return "−"
        case .multiply:
            return "×"
        case .divide:
            return "÷"
        case .percent:
            return "%"
        case .plusMinus:
            return "+/−"
        case .clear:
            return "AC"
        case .backspace:
            return "⌫"
        }
    }

    var operation: CalculatorOperation? {
        switch self {
        case .add:
            return .add
        case .subtract:
            return .subtract
        case .multiply:
            return .multiply
        case .divide:
            return .divide
        default:
            return nil
        }
    }

    var backgroundColor: Color {
        switch self {
        case .add, .subtract, .multiply, .divide, .equals:
            return .orange
        case .clear, .percent, .plusMinus, .backspace:
            return Color.gray.opacity(0.8)
        default:
            return Color(white: 0.2)
        }
    }

    var foregroundColor: Color {
        .white
    }
}
