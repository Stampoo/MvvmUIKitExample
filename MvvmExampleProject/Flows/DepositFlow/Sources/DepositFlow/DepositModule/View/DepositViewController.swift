//
//  Copyright © Surf. All rights reserved.
//

import UIKit
import Core

final class DepositViewController<ViewModel: DepositViewModel>: UIViewController {

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

private extension DepositViewController {

    func setupInitialState() { }

}
