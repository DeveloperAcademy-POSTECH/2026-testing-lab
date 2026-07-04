//
//  Calculator.swift
//  CalculatorTesting
//
//  Created by sun on 7/3/26.
//

import Foundation

struct Calculator {
    func calculate(lhs: Decimal, rhs: Decimal, operation: CalculatorOperation) -> Decimal? {
        switch operation {
        case .add:
            return lhs + rhs
        case .subtract:
            return lhs - rhs
        case .multiply:
            return lhs * rhs
        case .divide:
            guard rhs != 0 else { return nil }
            return lhs / rhs
        }
    }

    func percent(of value: Decimal) -> Decimal {
        value / 100
    }

    func toggleSign(of value: Decimal) -> Decimal {
        value * -1
    }

    func string(from decimal: Decimal) -> String {
        let number = NSDecimalNumber(decimal: decimal)
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 10
        formatter.minimumFractionDigits = 0
        formatter.groupingSeparator = ","
        return formatter.string(from: number) ?? number.stringValue
    }

    func decimal(from string: String) -> Decimal? {
        Decimal(string: string.replacingOccurrences(of: ",", with: ""))
    }
}
