//
//  CalculatorTests.swift
//  CalculatorTesting
//
//  Created by sun on 7/4/26.
//

import XCTest
@testable import CalculatorTesting

final class CalculatorTests: XCTestCase {

    private var logic: Calculator!

    override func setUp() {
        super.setUp()
        logic = Calculator()
    }

    override func tearDown() {
        logic = nil
        super.tearDown()
    }

    func testAddition() {
        XCTAssertEqual(logic.calculate(lhs: 10, rhs: 5, operation: .add), 15)
    }

    func testSubtraction() {
        XCTAssertEqual(logic.calculate(lhs: 10, rhs: 5, operation: .subtract), 5)
    }

    func testMultiplication() {
        XCTAssertEqual(logic.calculate(lhs: 10, rhs: 5, operation: .multiply), 50)
    }

    func testDivision() {
        XCTAssertEqual(logic.calculate(lhs: 10, rhs: 5, operation: .divide), 2)
    }

    func testDivisionByZeroReturnsNil() {
        XCTAssertNil(logic.calculate(lhs: 10, rhs: 0, operation: .divide))
    }

    func testPercent() {
        XCTAssertEqual(logic.percent(of: 50), 0.5)
    }

    func testToggleSign() {
        XCTAssertEqual(logic.toggleSign(of: 10), -10)
        XCTAssertEqual(logic.toggleSign(of: -10), 10)
    }

    func testDecimalFromString() {
        XCTAssertEqual(logic.decimal(from: "1,234.5"), Decimal(1234.5))
    }

    func testStringFromDecimal() {
        XCTAssertEqual(logic.string(from: 1234.5), "1,234.5")
    }
}
