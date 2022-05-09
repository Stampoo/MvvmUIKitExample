//
//  Publisher.swift
//  
//
//  Created by Князьков Илья on 01.05.2022.
//

import Combine

public extension Publisher where Self.Failure == Never {

    func optionalSink(receiveValue: @escaping ((Self.Output) -> Void?)) -> AnyCancellable {
        let erasedCallback: (Self.Output) -> Void = { output in
            receiveValue(output)
            return Void()
        }
        return sink(receiveValue: erasedCallback)
    }

}

public extension AnyPublisher where Self.Failure == Never {

    func optionalSink(receiveValue: @escaping ((Self.Output) -> Void?)) -> AnyCancellable {
        let erasedCallback: (Self.Output) -> Void = { output in
            receiveValue(output)
            return Void()
        }
        return sink(receiveValue: erasedCallback)
    }
}
