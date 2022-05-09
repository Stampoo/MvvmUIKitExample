//
//  DepositModelProtocol.swift
//  
//
//  Created by Князьков Илья on 03.05.2022.
//

import Foundation

protocol DepositModelProtocol {

    func getCurrentSelectedConditions() -> Set<DepositCondition>
    func getCurrentDisabledConditions() -> Set<DepositCondition>
    func getDepositPercentBasedOnCurrentConditions() -> Double
    func getTotalAmountBasedOnCurrentConditions() -> Double
    func getSelectedConditionsBasedOn(condition: DepositCondition) -> Set<DepositCondition>
    func getDisabledConditionsBasedOn(months: Int) -> Set<DepositCondition>

    func setAmount(_ amount: Double)
    func getAmountValidationResult() -> ValidationProtocol

}
