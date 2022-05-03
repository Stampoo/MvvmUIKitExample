//
//  DepositInformationPreinitModel.swift
//  
//
//  Created by Князьков Илья on 03.05.2022.
//

struct DepositInformationPreinitModel {

    let availableDepositTerms: [DepositTerm]
    let availableDepositConditions: [DepositCondition]

    init(terms: [DepositTerm], conditions: [DepositCondition]) {
        self.availableDepositTerms = terms
        self.availableDepositConditions = conditions
    }

}
