//
//  Copyright © Surf. All rights reserved.
//

import Core
import Combine

enum DepositEvents {
    case viewDidLoad
    case sumDidChanged(_ newSum: Double)
    case termDidChanged(_ newTermInMonth: Int)
    case conditionDidChanged(_ newCondition: DepositCondition)
}

protocol DepositViewOutput: BaseViewModuleOutput where Event == DepositEvents {

    typealias AnyPublisher = Combine.AnyPublisher

    var infoPreinitPublisher: AnyPublisher<DepositInformationPreinitModel, Never> { get }

}
