//
//  CalculatorViewModel.swift
//  Calculator
//
//  Created by sun on 7/3/26.
//

import Foundation
import Observation

@Observable
final class CalculatorViewModel {
    private(set) var displayText: String = "0"
    private(set) var expressionText: String = ""

    private let logic: Calculator

    private var currentInput: String = "0"
    private var storedValue: Decimal?
    private var pendingOperation: CalculatorOperation?
    private var isTypingNewNumber = false
    private var didTapEquals = false

    init(logic: Calculator = Calculator()) {
        self.logic = logic
    }

    func tap(_ button: CalculatorButtonType) {
        if case let .digit(number) = button {
            inputDigit(number)
            return
        }

        if let operation = button.operation {
            setOperation(operation)
            return
        }

        switch button {
        case .decimal:
            inputDecimal()
        case .equals:
            performEquals()
        case .percent:
            applyPercent()
        case .plusMinus:
            applyPlusMinus()
        case .clear:
            clearAll()
        case .backspace:
            backspace()
        default:
            break
        }
    }
}

// MARK: - Private

private extension CalculatorViewModel {
    func inputDigit(_ digit: Int) {
        if didTapEquals {
            resetState()
        }

        if isTypingNewNumber {
            currentInput = currentInput == "0" ? "\(digit)" : currentInput + "\(digit)"
        } else {
            currentInput = "\(digit)"
            isTypingNewNumber = true
        }

        updateDisplay()
    }

    func inputDecimal() {
        if didTapEquals {
            resetState()
        }

        if !isTypingNewNumber {
            currentInput = "0."
            isTypingNewNumber = true
        } else if !currentInput.contains(".") {
            currentInput += "."
        }

        updateDisplay()
    }

    func setOperation(_ operation: CalculatorOperation) {
        guard let currentValue = logic.decimal(from: currentInput) else { return }

        if let storedValue, let pendingOperation, isTypingNewNumber {
            guard let result = logic.calculate(lhs: storedValue, rhs: currentValue, operation: pendingOperation) else {
                showError()
                return
            }

            self.storedValue = result
            currentInput = logic.string(from: result)
        } else {
            storedValue = currentValue
        }

        expressionText = "\(logic.string(from: storedValue ?? currentValue))\(operation.symbol)"
        pendingOperation = operation
        isTypingNewNumber = false
        didTapEquals = false
        updateDisplay()
    }

    func performEquals() {
        guard let operation = pendingOperation,
              let lhs = storedValue,
              let rhs = logic.decimal(from: currentInput)
        else {
            return
        }

        guard let result = logic.calculate(lhs: lhs, rhs: rhs, operation: operation) else {
            showError()
            return
        }

        expressionText = "\(logic.string(from: lhs))\(operation.symbol)\(logic.string(from: rhs))"
        currentInput = logic.string(from: result)
        storedValue = nil
        pendingOperation = nil
        isTypingNewNumber = false
        didTapEquals = true
        updateDisplay()
    }

    func applyPercent() {
        guard let value = logic.decimal(from: currentInput) else { return }
        currentInput = logic.string(from: logic.percent(of: value))
        updateDisplay()
    }

    func applyPlusMinus() {
        guard let value = logic.decimal(from: currentInput) else { return }
        currentInput = logic.string(from: logic.toggleSign(of: value))
        updateDisplay()
    }

    func backspace() {
        guard isTypingNewNumber else { return }

        if currentInput.count > 1 {
            currentInput.removeLast()

            if currentInput == "-" {
                currentInput = "0"
                isTypingNewNumber = false
            }
        } else {
            currentInput = "0"
            isTypingNewNumber = false
        }

        updateDisplay()
    }

    func clearAll() {
        resetState()
        updateDisplay()
    }

    func showError() {
        displayText = "Error"
        resetState()
    }

    func updateDisplay() {
        if currentInput.hasSuffix(".") {
            let valueWithoutDecimalPoint = String(currentInput.dropLast())

            if let decimal = logic.decimal(from: valueWithoutDecimalPoint) {
                displayText = logic.string(from: decimal) + "."
            } else {
                displayText = currentInput
            }

            return
        }

        if let decimal = logic.decimal(from: currentInput) {
            displayText = logic.string(from: decimal)
        } else {
            displayText = currentInput
        }
    }

    func resetState() {
        currentInput = "0"
        storedValue = nil
        pendingOperation = nil
        isTypingNewNumber = false
        didTapEquals = false
    }
}
