//
//  DepositCoordinator.swift
//  
//
//  Created by Князьков Илья on 30.04.2022.
//

import Core

public final class DepositCoordinator: BaseCoordinator {

    // MARK: - BaseCoordinator

    @discardableResult
    public override func start() -> FinishableCoordinator {
        showDepositModule()
        return super.start()
    }

}

// MARK: - Private Methods

private extension DepositCoordinator {

    func showDepositModule() {
        let (view, _) = DepositModuleConfigurator.configure()
        router.setAsRoot(module: view)
    }

}
