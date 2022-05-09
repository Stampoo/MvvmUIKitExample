//
//  DepositModelTests.swift
//  
//
//  Created by Князьков Илья on 09.05.2022.
//

import XCTest
@testable import DepositFlow

final class DepositModelTests: XCTestCase {

    let model: DepositModelProtocol = DepositModel()
    let termsForDisabledConditions = DepositTerm.allCases.filter { $0.termInMonth >= 12 }.first
    let termsForEmptyDisabledConditions = DepositTerm.allCases.filter { $0.termInMonth < 12 }.first


    func testOnCorrectSelectedDepositConditions() {
        let replenishConditions = model.getSelectedConditionsBasedOn(condition: .withReplenishCondition)
        XCTAssertEqual(replenishConditions, [.withReplenishCondition])

        let doubledConditions = model.getSelectedConditionsBasedOn(condition: .withWithdrawCondition)
        XCTAssertEqual(doubledConditions, [.withReplenishCondition, .withWithdrawCondition])

        let withPercentageConditions = model.getSelectedConditionsBasedOn(condition: .withPercentCondition)
        XCTAssertEqual(withPercentageConditions, [.withPercentCondition])
    }

    func testOnCorrectSelectedDepositTerms() throws {
        let termsForEmptyDisabledConditions = try XCTUnwrap(self.termsForEmptyDisabledConditions)
        let emptyDisabledConditions = model
            .getDisabledConditionsBasedOn(months: termsForEmptyDisabledConditions.termInMonth)

        XCTAssertEqual(emptyDisabledConditions, [])

        let termsForDisabledConditions = try XCTUnwrap(self.termsForDisabledConditions)
        let disabledConditions = model
            .getDisabledConditionsBasedOn(months: termsForDisabledConditions.termInMonth)

        XCTAssertEqual(disabledConditions, [.withWithdrawCondition, .withReplenishCondition])
    }

    func testOnDiscardSelectedStateAfterPickMonths() throws {
        let termsForDisabledConditions = try XCTUnwrap(self.termsForDisabledConditions)

        _ = model.getSelectedConditionsBasedOn(condition: .withReplenishCondition)
        _ = model.getDisabledConditionsBasedOn(months: termsForDisabledConditions.termInMonth)

        let emptySelectedConditions = model.getCurrentSelectedConditions()

        XCTAssertEqual(emptySelectedConditions, [])
    }

    func testOnCorrectSelectedStateAfterPickMonths() throws {
        let termsForDisabledConditions = try XCTUnwrap(self.termsForDisabledConditions)

        _ = model.getSelectedConditionsBasedOn(condition: .withPercentCondition)
        _ = model.getDisabledConditionsBasedOn(months: termsForDisabledConditions.termInMonth)

        let nonEmptySelectedConditions = model.getCurrentSelectedConditions()

        XCTAssertEqual(nonEmptySelectedConditions, [.withPercentCondition])

        let termsForEmptyDisabledConditions = try XCTUnwrap(self.termsForEmptyDisabledConditions)

        _ = model.getSelectedConditionsBasedOn(condition: .withReplenishCondition)
        _ = model.getDisabledConditionsBasedOn(months: termsForEmptyDisabledConditions.termInMonth)

        let nonEmptySelectedConditionsWithReplenish = model.getCurrentSelectedConditions()

        XCTAssertEqual(nonEmptySelectedConditionsWithReplenish, [.withReplenishCondition])
    }

    func testOnCorrectSelectedItems() {
        _ = model.getSelectedConditionsBasedOn(condition: .withPercentCondition)
        XCTAssertEqual(model.getCurrentSelectedConditions(), [.withPercentCondition])

        _ = model.getSelectedConditionsBasedOn(condition: .withWithdrawCondition)
        XCTAssertEqual(model.getCurrentSelectedConditions(), [.withWithdrawCondition, .withReplenishCondition])

        _ = model.getSelectedConditionsBasedOn(condition: .withReplenishCondition)
        XCTAssertEqual(model.getCurrentSelectedConditions(), [.withReplenishCondition])
    }

    func testOnCorrectCalculateAmountAndPercentage() {
        let model = DepositModel()
        let amount: Double = 20_000
        let term: DepositTerm = .nineMounth

        let expectedPercent: Double = 15.12
        let expectedAmount = amount + amount * (15.12 / 100)

        print(expectedAmount)

        model.setAmount(amount)
        _ = model.getDisabledConditionsBasedOn(months: term.termInMonth)
        _ = model.getSelectedConditionsBasedOn(condition: .withWithdrawCondition)

        XCTAssertEqual(model.getDepositPercentBasedOnCurrentConditions(), expectedPercent)

        XCTAssertEqual(model.getTotalAmountBasedOnCurrentConditions(), expectedAmount)
    }

    func testOnCorrectSumValidation() {
        let model = DepositModel()
        let invalidUpperAmount: Double = 10_000_000
        let invalidLowerAmount: Double = 10_000
        let correntAmount: Double = 20_000

        model.setAmount(invalidUpperAmount)

        XCTAssertEqual(model.getAmountValidationResult().isValid, false)

        model.setAmount(invalidLowerAmount)

        XCTAssertEqual(model.getAmountValidationResult().isValid, false)

        model.setAmount(correntAmount)

        XCTAssertEqual(model.getAmountValidationResult().isValid, true)
    }

}
