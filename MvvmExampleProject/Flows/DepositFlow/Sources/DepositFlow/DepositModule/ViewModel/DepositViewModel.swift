//
//  Copyright © Surf. All rights reserved.
//

import EventTransceiver

final class DepositViewModel: DepositViewOutput, DepositModuleInput, DepositModuleOutput {

    // MARK: - DepositViewOutput

    var infoPreinitPublisher: AnyPublisher<DepositInformationPreinitModel, Never> {
        infoPreinitEventTransceiver.publisher.eraseToAnyPublisher()
    }
    var depositInfoPublisher: AnyPublisher<DepositInformationModel, Never> {
        depositInfoEventTransceiver.publisher.eraseToAnyPublisher()
    }

    // MARK: - Private Properties

    private let infoPreinitEventTransceiver = BaseEventTransceiver<DepositInformationPreinitModel, Never>()
    private let depositInfoEventTransceiver = BaseEventTransceiver<DepositInformationModel, Never>()
    private let model: DepositModelProtocol
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

    init(model: DepositModelProtocol) {
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
            updateDepositInformation()
        case .termDidChanged(let _):
            updateDepositInformation()
        }
    }

}

// MARK: - Private Methods

private extension DepositViewModel {

    func updateDepositInformation() {
        let bannerInfoModel = DepositInformationModel(
            percent: model.getDepositPercentBasedOnCurrentConditions(),
            amount: model.getTotalAmountBasedOnCurrentConditions()
        )
        depositInfoEventTransceiver.send(newValue: bannerInfoModel)
    }

}
