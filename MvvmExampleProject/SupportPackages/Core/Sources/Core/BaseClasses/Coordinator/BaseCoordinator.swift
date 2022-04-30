//
//  BaseCoordinator.swift
//  
//
//  Created by Князьков Илья on 30.04.2022.
//

open class BaseCoordinator: FinishableCoordinator, Coordinator {

    public typealias AbstractCoordinator = BaseCoordinator

    public var router: Router

    public required init(router: Router) {
        self.router = router
    }

    public override init() {
        router = BaseRouter()
    }

    open func start() -> FinishableCoordinator {
        self
    }

}
