//
//  PopUpContentProtocol.swift
//  
//
//  Created by Князьков Илья on 13.05.2022.
//

import UIKit

public protocol PopUpContentProtocol {

    var asViewRepresentable: UIView { get }
    var estimateHeight: CGFloat { get }
    var whiteSpaceBackgroundColor: UIColor { get }
    var isNeedCloseByTapOnBlurSpace: Bool { get }

}

public extension PopUpContentProtocol where Self: UIView{

    var asViewRepresentable: UIView {
        self
    }

    var estimateHeight: CGFloat {
        asViewRepresentable.frame.height
    }

    var whiteSpaceBackgroundColor: UIColor {
        .clear
    }

    var isNeedCloseByTapOnBlurSpace: Bool {
        true
    }

}
