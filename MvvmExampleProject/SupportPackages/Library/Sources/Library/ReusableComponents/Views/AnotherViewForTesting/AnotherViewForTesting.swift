//
//  AnotherViewForTesting.swift
//  
//
//  Created by Князьков Илья on 14.05.2022.
//

import UIKit

public final class AnotherViewForTesting: UIView, PopUpContentProtocol {

    public static func loadFromNibDirectly() -> Self {
        let nibName = String(describing: self)
        let nib = UINib(nibName: nibName, bundle: .module)

        guard let view = nib.instantiate(withOwner: self, options: nil).first as? Self else {
            preconditionFailure("\(Self.self) was not loaded from nib")
        }
        return view
    }

}
