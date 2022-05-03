//
//  Copyright © Surf. All rights reserved.
//

import EventTransceiver

final class DepositViewModel: DepositViewOutput, DepositModuleInput, DepositModuleOutput {

    // MARK: - DepositViewOutput

    var infoPreinitPublisher: AnyPublisher<DepositInformationPreinitModel, Never> {
        infoPreinitEventTransceiver.publisher.eraseToAnyPublisher()
    }

    // MARK: - Private Properties

    private let infoPreinitEventTransceiver = BaseEventTransceiver<DepositInformationPreinitModel, Never>()
    private let model: DepositModel
    private let availableDepositTerms: [DepositTerm] = [
        .threeMounth,
        .sixMounth,
        .nineMounth,
        .oneYear,
        .oneAndHalfYear
    ]
    private let availableDepositConditions: [DepositCondition] = [
        .withReplenishCondition,
        .withWithdrawCondition,
        .withPercentCondition
    ]

    // MARK: - Initialization

    init(model: DepositModel) {
        self.model = model
    }

    // MARK: - DepositViewOutput

    func didEventTriggered(_ triggeredEvent: DepositEvents) {
        switch triggeredEvent {
        case .viewDidLoad:
            let preinitModel = DepositInformationPreinitModel(
                terms: availableDepositTerms,
                conditions: availableDepositConditions
            )
            infoPreinitEventTransceiver.send(newValue: preinitModel)
        case .sumDidChanged(let _):
            break
        case .termDidChanged(let _):
            break
        }
    }

}
