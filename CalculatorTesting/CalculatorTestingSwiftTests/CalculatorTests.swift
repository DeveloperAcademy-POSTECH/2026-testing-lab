//
//  CalculatorTests.swift
//  CalculatorTesting
//
//  Created by sun on 7/6/26.
//

import Foundation
import Testing
@testable import CalculatorTesting

struct CalculatorTests {

    private let logic = Calculator()

    @Test
    func addition() {
        #expect(logic.calculate(lhs: 10, rhs: 5, operation: .add) == 15)
    }

    @Test
    func subtraction() {
        #expect(logic.calculate(lhs: 10, rhs: 5, operation: .subtract) == 5)
    }

    @Test
    func multiplication() {
        #expect(logic.calculate(lhs: 10, rhs: 5, operation: .multiply) == 50)
    }

    @Test
    func division() {
        #expect(logic.calculate(lhs: 10, rhs: 5, operation: .divide) == 2)
    }

    @Test
    func divisionByZeroReturnsNil() {
        #expect(logic.calculate(lhs: 10, rhs: 0, operation: .divide) == nil)
    }

    @Test
    func percent() {
        #expect(logic.percent(of: 50) == 0.5)
    }

    @Test
    func toggleSign() {
        #expect(logic.toggleSign(of: 10) == -10)
        #expect(logic.toggleSign(of: -10) == 10)
    }

    @Test
    func decimalFromString() {
        #expect(logic.decimal(from: "1,234.5") == Decimal(1234.5))
    }

    @Test
    func stringFromDecimal() {
        #expect(logic.string(from: 1234.5) == "1,234.5")
    }
}
