//
//  Copyright © Surf. All rights reserved.
//

final class DepositModel: DepositModelProtocol {

    // MARK: - Nested Types

    private enum Constants {
        static let mothsTresholdForDisableConditions = 12
        static let disabledConditions: Set<DepositCondition> = [.withReplenishCondition, .withWithdrawCondition]
    }

    // MARK: - Private Properties

    var currentSelectedConditions: Set<DepositCondition> = []
    var currrentDisabledConditions: Set<DepositCondition> = []

    // MARK: - DepositModelProtocol

    func getCurrentSelectedConditions() -> Set<DepositCondition> {
        currentSelectedConditions
    }

    func getCurrentDisabledConditions() -> Set<DepositCondition> {
        currrentDisabledConditions
    }

    func getDepositPercentBasedOnCurrentConditions() -> Double {
        .zero
    }

    func getTotalAmountBasedOnCurrentConditions() -> Double {
        .zero
    }

    func getSelectedConditionsBasedOn(condition: DepositCondition) -> Set<DepositCondition> {
        guard case .withWithdrawCondition = condition else {
            currentSelectedConditions = [condition]
            return currentSelectedConditions
        }
        currentSelectedConditions = [condition, .withReplenishCondition]
        return currentSelectedConditions
    }

    func getDisabledConditionsBasedOn(months: Int) -> Set<DepositCondition> {
        guard months >= Constants.mothsTresholdForDisableConditions else {
            currrentDisabledConditions = []
            return []
        }
        updateCurrentSelectedConditionsWithDisabled()
        currrentDisabledConditions = Constants.disabledConditions
        return Constants.disabledConditions
    }

}

// MARK: - Private Methods

private extension DepositModel {

    func updateCurrentSelectedConditionsWithDisabled() {
        currentSelectedConditions = currentSelectedConditions.filter { condition in
            Constants.disabledConditions.contains(condition) ? false : true
        }
    }

}
