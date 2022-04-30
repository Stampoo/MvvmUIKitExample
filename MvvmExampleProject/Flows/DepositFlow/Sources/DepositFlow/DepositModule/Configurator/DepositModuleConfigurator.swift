//
//  Copyright © Surf. All rights reserved.
//

import UIKit

enum DepositModuleConfigurator {

    typealias Module = (view: UIViewController, output: DepositModuleOutput)

    // MARK: - Internal Methods

    static func configure() -> Module {
        let view = DepositViewController<DepositViewModel>()
        let model = DepositModel()
        let viewModel = DepositViewModel(model: model)

        view.setViewModel(viewModel)

        return (view, viewModel)
    }

}
