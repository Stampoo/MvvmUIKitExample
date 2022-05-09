//
//  DepositConditionState.swift
//  
//
//  Created by Князьков Илья on 07.05.2022.
//

import Foundation

public enum DepositConditionState {
    case canBeChosen
    case cannotBeChosen
    case selected
}

extension DepositConditionState: Equatable {

    var isDisabled: Bool {
        self == .cannotBeChosen ? true: false
    }

    var isSelected: Bool {
        self == .selected ? true : false
    }

}
