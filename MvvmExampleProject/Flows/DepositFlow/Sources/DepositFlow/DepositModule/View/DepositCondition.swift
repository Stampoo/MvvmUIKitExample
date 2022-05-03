//
//  DepositCondition.swift
//  
//
//  Created by Князьков Илья on 03.05.2022.
//

struct DepositCondition {

    let title: String
    let description: String

}

extension DepositCondition {

    static var withReplenishCondition: Self {
        .init(title: "С пополнением", description: "Сроком только до 1 года")
    }

    static var withWithdrawCondition: Self {
        .init(title: "С частичным снятием", description: "Вместе с пополнением")
    }

    static var withPercentCondition: Self {
        .init(title: "Оставлять проценты на вкладе", description: "Капитализация")
    }

}
