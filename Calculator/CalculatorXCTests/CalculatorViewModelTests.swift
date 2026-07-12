//
//  CalculatorViewModelTests.swift
//  Calculator
//
//  Created by sun on 7/4/26.
//

import XCTest
@testable import Calculator

final class CalculatorViewModelTests: XCTestCase {

    private var viewModel: CalculatorViewModel!

    override func setUp() {
        super.setUp()
        viewModel = CalculatorViewModel(logic: Calculator())
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testNumberInput() {
        viewModel.tap(.digit(1))
        viewModel.tap(.digit(2))
        viewModel.tap(.digit(3))

        XCTAssertEqual(viewModel.displayText, "123")
    }

    func testDecimalInput() {
        viewModel.tap(.digit(1))
        viewModel.tap(.decimal)
        viewModel.tap(.digit(5))

        XCTAssertEqual(viewModel.displayText, "1.5")
    }

    func testAdditionFlow() {
        viewModel.tap(.digit(7))
        viewModel.tap(.add)
        viewModel.tap(.digit(8))
        viewModel.tap(.equals)

        XCTAssertEqual(viewModel.displayText, "15")
    }

    func testSubtractionFlow() {
        viewModel.tap(.digit(9))
        viewModel.tap(.subtract)
        viewModel.tap(.digit(4))
        viewModel.tap(.equals)

        XCTAssertEqual(viewModel.displayText, "5")
    }

    func testMultiplicationFlow() {
        viewModel.tap(.digit(6))
        viewModel.tap(.multiply)
        viewModel.tap(.digit(7))
        viewModel.tap(.equals)

        XCTAssertEqual(viewModel.displayText, "42")
    }

    func testDivisionFlow() {
        viewModel.tap(.digit(8))
        viewModel.tap(.divide)
        viewModel.tap(.digit(2))
        viewModel.tap(.equals)

        XCTAssertEqual(viewModel.displayText, "4")
    }

    func testClear() {
        viewModel.tap(.digit(9))
        viewModel.tap(.clear)

        XCTAssertEqual(viewModel.displayText, "0")
    }

    func testBackspace() {
        viewModel.tap(.digit(1))
        viewModel.tap(.digit(2))
        viewModel.tap(.digit(3))

        viewModel.tap(.backspace)

        XCTAssertEqual(viewModel.displayText, "12")
    }

    func testBackspaceToZero() {
        viewModel.tap(.digit(5))
        viewModel.tap(.backspace)

        XCTAssertEqual(viewModel.displayText, "0")
    }

    func testPlusMinus() {
        viewModel.tap(.digit(5))
        viewModel.tap(.plusMinus)

        XCTAssertEqual(viewModel.displayText, "-5")
    }

    func testPercent() {
        viewModel.tap(.digit(5))
        viewModel.tap(.digit(0))
        viewModel.tap(.percent)

        XCTAssertEqual(viewModel.displayText, "0.5")
    }

    func testDivisionByZeroShowsError() {
        viewModel.tap(.digit(8))
        viewModel.tap(.divide)
        viewModel.tap(.digit(0))
        viewModel.tap(.equals)

        XCTAssertEqual(viewModel.displayText, "Error")
    }

    func testDigitAfterEqualsStartsNewCalculation() {
        viewModel.tap(.digit(2))
        viewModel.tap(.add)
        viewModel.tap(.digit(3))
        viewModel.tap(.equals)

        viewModel.tap(.digit(7))

        XCTAssertEqual(viewModel.displayText, "7")
    }
}
