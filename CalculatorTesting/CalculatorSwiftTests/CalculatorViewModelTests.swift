//
//  CalculatorViewModelTests.swift
//  Calculator
//
//  Created by sun on 7/6/26.
//

import Testing
@testable import Calculator

struct CalculatorViewModelTests {

    private let viewModel = CalculatorViewModel(logic: Calculator())

    @Test
    func numberInput() {
        viewModel.tap(.digit(1))
        viewModel.tap(.digit(2))
        viewModel.tap(.digit(3))

        #expect(viewModel.displayText == "123")
    }

    @Test
    func decimalInput() {
        viewModel.tap(.digit(1))
        viewModel.tap(.decimal)
        viewModel.tap(.digit(5))

        #expect(viewModel.displayText == "1.5")
    }

    @Test
    func additionFlow() {
        viewModel.tap(.digit(7))
        viewModel.tap(.add)
        viewModel.tap(.digit(8))
        viewModel.tap(.equals)

        #expect(viewModel.displayText == "15")
    }

    @Test
    func subtractionFlow() {
        viewModel.tap(.digit(9))
        viewModel.tap(.subtract)
        viewModel.tap(.digit(4))
        viewModel.tap(.equals)

        #expect(viewModel.displayText == "5")
    }

    @Test
    func multiplicationFlow() {
        viewModel.tap(.digit(6))
        viewModel.tap(.multiply)
        viewModel.tap(.digit(7))
        viewModel.tap(.equals)

        #expect(viewModel.displayText == "42")
    }

    @Test
    func divisionFlow() {
        viewModel.tap(.digit(8))
        viewModel.tap(.divide)
        viewModel.tap(.digit(2))
        viewModel.tap(.equals)

        #expect(viewModel.displayText == "4")
    }

    @Test
    func clear() {
        viewModel.tap(.digit(9))
        viewModel.tap(.clear)

        #expect(viewModel.displayText == "0")
    }

    @Test
    func backspace() {
        viewModel.tap(.digit(1))
        viewModel.tap(.digit(2))
        viewModel.tap(.digit(3))

        viewModel.tap(.backspace)

        #expect(viewModel.displayText == "12")
    }

    @Test
    func backspaceToZero() {
        viewModel.tap(.digit(5))
        viewModel.tap(.backspace)

        #expect(viewModel.displayText == "0")
    }

    @Test
    func plusMinus() {
        viewModel.tap(.digit(5))
        viewModel.tap(.plusMinus)

        #expect(viewModel.displayText == "-5")
    }

    @Test
    func percent() {
        viewModel.tap(.digit(5))
        viewModel.tap(.digit(0))
        viewModel.tap(.percent)

        #expect(viewModel.displayText == "0.5")
    }

    @Test
    func divisionByZeroShowsError() {
        viewModel.tap(.digit(8))
        viewModel.tap(.divide)
        viewModel.tap(.digit(0))
        viewModel.tap(.equals)

        #expect(viewModel.displayText == "Error")
    }

    @Test
    func digitAfterEqualsStartsNewCalculation() {
        viewModel.tap(.digit(2))
        viewModel.tap(.add)
        viewModel.tap(.digit(3))
        viewModel.tap(.equals)

        viewModel.tap(.digit(7))

        #expect(viewModel.displayText == "7")
    }
}
