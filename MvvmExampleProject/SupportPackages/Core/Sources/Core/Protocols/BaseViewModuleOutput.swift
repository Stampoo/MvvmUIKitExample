//
//  BaseViewModuleOutput.swift
//  
//
//  Created by Князьков Илья on 30.04.2022.
//

import EventTransceiver

public protocol BaseViewModuleOutput {

    typealias EventTransceiver<Input> = BaseEventTransceiver<Input, Never>
    typealias RegularEventPublisher<Input> = EventPublisher<EventTransceiver<Input>, Input, Never>

    associatedtype Event

    func didEventTriggered(_ triggeredEvent: Event)

}
