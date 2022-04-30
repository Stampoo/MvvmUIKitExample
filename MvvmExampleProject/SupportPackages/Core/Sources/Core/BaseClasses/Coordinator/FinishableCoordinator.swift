//
//  FinishableCoordinator.swift
//  
//
//  Created by Князьков Илья on 30.04.2022.
//

open class FinishableCoordinator: Hashable {

    private weak var parent: FinishableCoordinator?
    private var childCoordinators: Set<FinishableCoordinator> = []

    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }

    public static func == (lhs: FinishableCoordinator, rhs: FinishableCoordinator) -> Bool {
        lhs === rhs
    }

    @discardableResult
    public func store(in parent: FinishableCoordinator) -> Self {
        self.parent = parent
        parent.childCoordinators.insert(self)
        return self
    }

    public func finish() {
        parent?.childCoordinators.remove(self)
    }

}
