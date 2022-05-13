//
//  InteractiveTransitionBridgeProtocol.swift
//  
//
//  Created by Князьков Илья on 14.05.2022.
//

import UIKit

protocol InteractiveTransitionBridgeProtocol: UIPercentDrivenInteractiveTransition {

    associatedtype TransitionDirection

    var direction: TransitionDirection { get }

    func updateDirection(_ newDirection: TransitionDirection)
    func bind(to controller: UIViewController)

}
