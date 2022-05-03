//
//  DepositTerms.swift
//  
//
//  Created by Князьков Илья on 02.05.2022.
//

import Foundation

enum DepositTerms {
    case base(_ title: String)
}

extension DepositTerms {

    var title: String {
        switch self {
        case .base(let title):
            return title
        }
    }

}

// MARK: - Default terms

extension DepositTerms {

    static var threeMounth: Self {
        .base("3 мес.")
    }

    static var sixMounth: Self {
        .base("6 мес.")
    }

    static var nineMounth: Self {
        .base("9 мес.")
    }

    static var oneYear: Self {
        .base("1 год")
    }

    static var oneAndHalfYear: Self {
        .base("1,5 года")
    }

}
