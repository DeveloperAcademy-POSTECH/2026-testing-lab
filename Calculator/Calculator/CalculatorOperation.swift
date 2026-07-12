//
//  CalculatorOperation.swift
//  Calculator
//
//  Created by sun on 7/3/26.
//

import Foundation

enum CalculatorOperation {
    case add, subtract, multiply, divide

    var symbol: String {
        switch self {
        case .add: return "+"
        case .subtract: return "−"
        case .multiply: return "×"
        case .divide: return "÷"
        }
    }
}
