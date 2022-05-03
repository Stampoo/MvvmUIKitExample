//
//  DepositTerms.swift
//  
//
//  Created by Князьков Илья on 02.05.2022.
//

import Foundation

struct DepositTerm {
    let title: String
    let termInMonth: Int
}

// MARK: - Default terms

extension DepositTerm {

    static var threeMounth: Self {
        DepositTerm(title: "3 мес.", termInMonth: 3)
    }

    static var sixMounth: Self {
        DepositTerm(title:"6 мес.", termInMonth: 6)
    }

    static var nineMounth: Self {
        DepositTerm(title: "9 мес.", termInMonth: 9)
    }

    static var oneYear: Self {
        DepositTerm(title: "1 год", termInMonth: 12)
    }

    static var oneAndHalfYear: Self {
        DepositTerm(title: "1,5 года", termInMonth: 18)
    }

}
