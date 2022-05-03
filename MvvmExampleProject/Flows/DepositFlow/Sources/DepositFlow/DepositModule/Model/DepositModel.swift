//
//  Copyright © Surf. All rights reserved.
//

struct DepositModel: DepositModelProtocol {

    func getDepositPercentBasedOnCurrentConditions() -> Double {
        .zero
    }

    func getTotalAmountBasedOnCurrentConditions() -> Double {
        .zero
    }

    func getSelectedConditionsBasedOn(condition: DepositCondition) -> Set<DepositCondition> {
        []
    }

    func getDisabledConditionsBasedOn(months: Int) -> Set<DepositCondition> {
        []
    }

}
