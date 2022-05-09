//
//  Copyright © Surf. All rights reserved.
//

final class SuccessPageViewModel: SuccessPageViewOutput, SuccessPageModuleInput, SuccessPageModuleOutput {

    // MARK: - SuccessPageModuleOutput

    var onCloseDidTriggered: (() -> Void)?

    // MARK: - Private Properties

    private let model: SuccessPageModel

    // MARK: - Initialization

    init(model: SuccessPageModel) {
        self.model = model
    }

    // MARK: - SuccessPageViewOutput

    func didEventTriggered(_ triggeredEvent: SuccessPageEvents) {
        switch triggeredEvent {
        case .closeDidPressed:
            onCloseDidTriggered?()
        }
    }

}
