//
//  RouterPresentableElement.swift
//  
//
//  Created by Князьков Илья on 30.04.2022.
//

import UIKit

public protocol RouterPresentableElement {

    var presentableController: UIViewController { get }

}

extension UIViewController: RouterPresentableElement {

    public var presentableController: UIViewController {
        self
    }

}
