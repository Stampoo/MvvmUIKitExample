//
//  DepositSumCellModel.swift
//  
//
//  Created by Князьков Илья on 01.05.2022.
//

import Core
import Combine
import UIKit

public struct DepositSumCellModel {

    // MARK: - Nested Types

    public enum State {
        case common(text: String)
        case error(text: String)
    }

    // MARK: - Internal Properties

    let title: String
    private(set) internal var state: State
    let sumDidChangeEvent = BaseEventTransceiver<Double, Never>()

    // MARK: - Public Properties

    public var sumDidChangePublisher: AnyPublisher<Double, Never> {
        sumDidChangeEvent.publisher.eraseToAnyPublisher()
    }

    // MARK: - Initialiaztion

    public init(title: String, state: State) {
        self.title = title
        self.state = state
    }

    // MARK: - Public Methods

    public mutating func set(state: State) {
        self.state = state
    }

}

public extension DepositSumCellModel.State {

    var text: String {
        switch self {
        case .common(let text):
            return text
        case .error(let text):
            return text
        }
    }

    var textColor: UIColor {
        switch self {
        case .common:
            return .systemGray
        case .error:
            return .systemRed
        }
    }

}
