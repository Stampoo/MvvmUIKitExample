//
//  Copyright © Surf. All rights reserved.
//

import UIKit
import Core

final class SuccessPageViewController<ViewModel: SuccessPageViewOutput>: BaseViewController {

    // MARK: - Private Properties

    private var viewModel: ViewModel?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialState()
    }

    // MARK: - Internal Methods

    func setViewModel(_ viewModel: ViewModel) {
        self.viewModel = viewModel
    }

}

// MARK: - Private Methods

private extension SuccessPageViewController {

    func setupInitialState() { }

}
