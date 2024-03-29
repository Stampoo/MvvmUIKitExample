//
//  DepositCondition.swift
//  
//
//  Created by Князьков Илья on 03.05.2022.
//

struct DepositCondition: Hashable {

    let title: String
    let description: String
    let depositPercentQuantity: Double

    var isDisabled: Bool = false
    var isSelected: Bool = false

}

extension DepositCondition {

    static var withReplenishCondition: Self {
        .init(
            title: "С пополнением",
            description: "Сроком только до 1 года",
            depositPercentQuantity: 0.8
        )
    }

    static var withWithdrawCondition: Self {
        .init(
            title: "С частичным снятием",
            description: "Вместе с пополнением",
            depositPercentQuantity: 0.7
          )
    }

    static var withPercentCondition: Self {
        .init(
            title: "Оставлять проценты на вкладе",
            description: "Капитализация",
            depositPercentQuantity: 1.1
        )
    }

}
