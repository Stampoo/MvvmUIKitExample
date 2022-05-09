//
//  Copyright © Surf. All rights reserved.
//

final class DepositModel: DepositModelProtocol {

    // MARK: - Nested Types

    private enum Constants {
        static let mothsTresholdForDisableConditions = 12
        static let disabledConditions: Set<DepositCondition> = [.withReplenishCondition, .withWithdrawCondition]

        static let upperSumTreshold: Double = 10_000_000
        static let lowerSumTreshold: Double = 15_000
        static let percentMagnitude: Double = 100
    }

    // MARK: - Private Properties

    private var currentSelectedConditions: Set<DepositCondition> = []
    private var currrentDisabledConditions: Set<DepositCondition> = []
    private var currentSum: Double = .zero
    private var currentTermInMonths: Int = .zero

    // MARK: - DepositModelProtocol

    func getCurrentSelectedConditions() -> Set<DepositCondition> {
        currentSelectedConditions
    }

    func getCurrentDisabledConditions() -> Set<DepositCondition> {
        currrentDisabledConditions
    }

    func getDepositPercentBasedOnCurrentConditions() -> Double {
        let termPercent = Double(currentTermInMonths * 3)
        let correctPercentWithConditions = currentSelectedConditions.reduce(termPercent) { partialResult, condition in
            partialResult * condition.depositPercentQuantity
        }
        return correctPercentWithConditions
    }

    func getTotalAmountBasedOnCurrentConditions() -> Double {
        currentSum + currentSum * (getDepositPercentBasedOnCurrentConditions() / Constants.percentMagnitude)
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
        self.currentTermInMonths = months
        guard months >= Constants.mothsTresholdForDisableConditions else {
            currrentDisabledConditions = []
            return []
        }
        updateCurrentSelectedConditionsWithDisabled()
        currrentDisabledConditions = Constants.disabledConditions
        return Constants.disabledConditions
    }

    func setAmount(_ amount: Double) {
        self.currentSum = amount
    }

    func getAmountValidationResult() -> ValidationProtocol {
        let isNotSmallerThanLower = currentSum > Constants.lowerSumTreshold
        let isNotMoreThanUpper = currentSum < Constants.upperSumTreshold
        return Validation(isNotSmallerThanLower && isNotMoreThanUpper)
            .replaceSuccessDescription(with: "от \(Int(Constants.lowerSumTreshold))")
            .replaceFailureDescription(
                with: isNotSmallerThanLower ? "до \(Int(Constants.upperSumTreshold))" : "от \(Int(Constants.lowerSumTreshold))"
            )
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
