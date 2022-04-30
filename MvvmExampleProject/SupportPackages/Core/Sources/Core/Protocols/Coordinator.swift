//
//  Coordinator.swift
//  
//
//  Created by Князьков Илья on 30.04.2022.
//

public protocol Coordinator: AnyObject {

    associatedtype AbstractCoordinator: Coordinator

    var router: Router { get }

    init(router: Router)

    func start() -> FinishableCoordinator

}
