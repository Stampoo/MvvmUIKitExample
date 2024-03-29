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
    case openDepositDidPressed
}

protocol DepositViewOutput: BaseViewModuleOutput where Event == DepositEvents {

    typealias AnyPublisher = Combine.AnyPublisher

    var infoPreinitPublisher: AnyPublisher<DepositInformationPreinitModel, Never> { get }
    var depositInfoPublisher: AnyPublisher<DepositInformationModel, Never> { get }
    var depositConditionsPublisher: AnyPublisher<[DepositCondition], Never> { get }
    var depositSumValidationPublisher: AnyPublisher<ValidationProtocol, Never> { get }
    var openDepositPossibilityPublisher: AnyPublisher<Bool, Never> { get }

}
