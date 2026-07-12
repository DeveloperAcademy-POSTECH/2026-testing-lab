//
//  CalculatorView.swift
//  CalculatorTesting
//
//  Created by sun on 7/3/26.
//

import SwiftUI

struct CalculatorView: View {
    @State private var viewModel = CalculatorViewModel()

    private let rows: [[CalculatorButtonType]] = [
        [.backspace, .clear, .percent, .divide],
        [.digit(7), .digit(8), .digit(9), .multiply],
        [.digit(4), .digit(5), .digit(6), .subtract],
        [.digit(1), .digit(2), .digit(3), .add],
        [.plusMinus, .digit(0), .decimal, .equals]
    ]

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 12) {
                Spacer()

                HStack {
                    Spacer()

                    VStack(alignment: .trailing, spacing: 8) {
                        Text(viewModel.expressionText)
                            .foregroundColor(.gray)
                            .font(.system(size: 40, weight: .light))
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)

                        Text(viewModel.displayText)
                            .foregroundColor(.white)
                            .font(.system(size: 72, weight: .light))
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.bottom, 12)

                VStack(spacing: 12) {
                    ForEach(Array(rows.enumerated()), id: \.offset) { _, row in
                        HStack(spacing: 12) {
                            ForEach(row, id: \.self) { button in
                                CalculatorButtonView(button: button) {
                                    viewModel.tap(button)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
    }
}
