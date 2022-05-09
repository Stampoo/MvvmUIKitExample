//
//  Copyright © Surf. All rights reserved.
//

final class SuccessPageViewModel: SuccessPageViewOutput, SuccessPageModuleInput, SuccessPageModuleOutput {

    // MARK: - Private Properties

    private let model: SuccessPageModel

    // MARK: - Initialization

    init(model: SuccessPageModel) {
        self.model = model
    }

    // MARK: - SuccessPageViewOutput

    func didEventTriggered(_ triggeredEvent: Event) { }

}
