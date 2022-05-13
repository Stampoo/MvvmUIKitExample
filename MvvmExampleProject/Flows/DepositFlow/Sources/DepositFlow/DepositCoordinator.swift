//
//  DepositCoordinator.swift
//  
//
//  Created by Князьков Илья on 30.04.2022.
//

import Core
import Library

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
        let (view, output) = DepositModuleConfigurator.configure()

        output.onDepositDidOpened = { [weak self] in
            self?.showSuccessPageModule()
        }

        router.setAsRoot(module: view)
    }

    func showSuccessPageModule() {
        let (view, output) = SuccessPageModuleConfigurator.configure()
        
        output.onCloseDidTriggered = { [weak self] in
            self?.router.dismissTopPresentedModule(isAnimated: true)
        }

        //router.present(view.fullscreenPresentableController, isAnimated: true)
        let popUpConfigurator = PopUpConfigurator(content: DepositConditionView.loadFromNibDirectly())
        router.present(popUpConfigurator.getPreparedToPresentationContainer(), isAnimated: true)
    }

}
