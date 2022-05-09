//
//  Copyright © Surf. All rights reserved.
//

import UIKit

enum SuccessPageModuleConfigurator {

    typealias Module = (view: UIViewController, output: SuccessPageModuleOutput)

    // MARK: - Internal Methods

    static func configure() -> Module {
        let view = SuccessPageViewController<SuccessPageViewModel>()
        let model = SuccessPageModel()
        let viewModel = SuccessPageViewModel(model: model)

        view.setViewModel(viewModel)

        return (view, viewModel)
    }

}
