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
    var depositConditionsPublisher: AnyPublisher<[DepositCondition], Never> {
        depositConditionsTransceiver .publisher.eraseToAnyPublisher()
    }

    // MARK: - Private Properties

    private let infoPreinitEventTransceiver = BaseEventTransceiver<DepositInformationPreinitModel, Never>()
    private let depositInfoEventTransceiver = BaseEventTransceiver<DepositInformationModel, Never>()
    private let depositConditionsTransceiver  = BaseEventTransceiver<[DepositCondition], Never>()
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
        case .termDidChanged(let termInMoths):
            updateConditions(dependOn: termInMoths)
            updateDepositInformation()
        case .conditionDidChanged(let newCondition):
            updateConditions(dependOn: newCondition)
        }
    }

}

// MARK: - Private Methods

private extension DepositViewModel {

    func updateConditions(dependOn months: Int) {
        let selectedConditions = model.getCurrentSelectedConditions()
        let disabledConditions = model.getDisabledConditionsBasedOn(months: months)
        let newConditions: [DepositCondition] = availableDepositConditions.map { condition in
            var transformedCondition = condition
            if selectedConditions.contains(condition) {
                transformedCondition.isSelected = true
            }
            guard disabledConditions.contains(condition) else {
                return transformedCondition
            }
            transformedCondition.isDisabled = true
            return transformedCondition
        }
        depositConditionsTransceiver.send(newValue: newConditions)
    }

    func updateConditions(dependOn selectedCondition: DepositCondition) {
        let selectedConditions = model.getSelectedConditionsBasedOn(condition: selectedCondition)
        let disabledConditions = model.getCurrentDisabledConditions()
        let newConditions: [DepositCondition] = availableDepositConditions.map { condition in
            var transformedCondition = condition
            if disabledConditions.contains(condition) {
                transformedCondition.isDisabled = true
            }
            guard selectedConditions.contains(condition) else {
                return transformedCondition
            }
            transformedCondition.isSelected = true
            return transformedCondition
        }
        depositConditionsTransceiver.send(newValue: newConditions)
    }

    func updateDepositInformation() {
        let bannerInfoModel = DepositInformationModel(
            percent: model.getDepositPercentBasedOnCurrentConditions(),
            amount: model.getTotalAmountBasedOnCurrentConditions()
        )
        depositInfoEventTransceiver.send(newValue: bannerInfoModel)
    }

}
