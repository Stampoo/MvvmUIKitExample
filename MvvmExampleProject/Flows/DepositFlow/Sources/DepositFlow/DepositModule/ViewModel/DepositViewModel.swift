//
//  Copyright © Surf. All rights reserved.
//

final class DepositViewModel: DepositViewOutput, DepositModuleInput, DepositModuleOutput {

    // MARK: - Private Properties

    private let model: DepositModel

    // MARK: - Initialization

    init(model: DepositModel) {
        self.model = model
    }

    // MARK: - DepositViewOutput

    func didEventTriggered(_ triggeredEvent: Event) { }

}
