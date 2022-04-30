//
//  CoordinatorTests.swift
//  
//
//  Created by Князьков Илья on 30.04.2022.
//

import XCTest
@testable import Core

final class CoordinatorTests: XCTestCase {

    private let rootCoordinator = BaseCoordinator()
    private weak var deallocCoordinator: FinishableCoordinator?

    func testDeallocCoordinator() {
        _ = rootCoordinator.start()

        deallocCoordinator = BaseCoordinator()
            .start()
            .store(in: rootCoordinator)

        XCTAssertNotNil(deallocCoordinator)

        deallocCoordinator?.finish()

        XCTAssertEqual(deallocCoordinator, nil)
    }

}
