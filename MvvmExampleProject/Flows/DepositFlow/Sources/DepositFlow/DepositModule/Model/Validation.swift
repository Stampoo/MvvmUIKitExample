//
//  Validation.swift
//  
//
//  Created by Князьков Илья on 09.05.2022.
//

import Foundation


protocol ValidationProtocol {

    var isValid: Bool { get }
    var description: String { get }

}

struct Validation: ValidationProtocol {

    let isValid: Bool
    let successDescription: String
    let failureDescription: String

    var description: String {
        isValid ? successDescription : failureDescription
    }

    init(_ validationBlock: () -> Bool) {
        self.isValid = validationBlock()
        self.successDescription = ""
        self.failureDescription = ""
    }

    init(_ validationBlock: @autoclosure () -> Bool) {
        isValid = validationBlock()
        self.successDescription = ""
        self.failureDescription = ""
    }

    private init(isValid: Bool, successDescription: String, failureDescription: String) {
        self.isValid = isValid
        self.successDescription = successDescription
        self.failureDescription = failureDescription
    }

    func replaceSuccessDescription(with text: String) -> Validation {
        guard isValid else  {
            return self
        }
        return Validation(isValid: isValid, successDescription: text, failureDescription: "")
    }

    func replaceFailureDescription(with text: String) -> Validation {
        guard !isValid else  {
            return self
        }
        return Validation(isValid: isValid, successDescription: "", failureDescription: text)
    }

}
