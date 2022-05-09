//
//  ValidationTests.swift
//  
//
//  Created by Князьков Илья on 09.05.2022.
//

import XCTest
@testable import DepositFlow

final class ValidationTests: XCTestCase {

    func testOnCorrectValidation() {
        let isValidValue = true
        let successMessage = "Success"
        let failureMessage = "Failure"
        let validation = Validation(isValidValue)
            .replaceSuccessDescription(with: successMessage)
            .replaceFailureDescription(with: failureMessage)

        XCTAssertEqual(isValidValue, validation.isValid)
        XCTAssertEqual(validation.description, successMessage)

        let failureValidation = Validation(!isValidValue)
            .replaceSuccessDescription(with: successMessage)
            .replaceFailureDescription(with: failureMessage)

        XCTAssertEqual(!isValidValue, failureValidation.isValid)
        XCTAssertEqual(failureValidation.description, failureMessage)
    }

}
