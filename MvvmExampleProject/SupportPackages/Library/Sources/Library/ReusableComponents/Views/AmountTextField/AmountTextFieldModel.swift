//
//  AmountTextFieldModel.swift
//  
//
//  Created by Князьков Илья on 01.05.2022.
//

import UIKit
import Core
import Combine

struct AmountTextFieldModel {

    enum Currency: String {
        case rub = "RUB"

        var mark: String {
            switch self {
            case .rub:
                return "₽"
            }
        }
    }

    let currency: Currency
    let insets: UIEdgeInsets
    let font: UIFont
    let textColor: UIColor

    var amountDidChangePublisher: AnyPublisher<Double, Never> {
        amountDidChangeEvent.publisher.eraseToAnyPublisher()
    }

    let amountDidChangeEvent = BaseEventTransceiver<Double, Never>()

}
