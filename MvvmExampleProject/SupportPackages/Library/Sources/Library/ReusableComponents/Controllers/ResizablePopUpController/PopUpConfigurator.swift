//
//  PopUpConfigurator.swift
//  
//
//  Created by Князьков Илья on 14.05.2022.
//

import UIKit

public struct PopUpConfigurator {

    let content: PopUpContentProtocol

    public init(content: PopUpContentProtocol) {
        self.content = content
    }

    public func getPreparedToPresentationContainer() -> UIViewController {
        PopUpContainerController(content: content)
    }

}
