//
//  LightViewController.swift
//  
//
//  Created by Князьков Илья on 09.05.2022.
//

import UIKit

open class LightViewController: UIViewController {

    open override var overrideUserInterfaceStyle: UIUserInterfaceStyle {
        get { .light }
        set { }
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.overrideUserInterfaceStyle = .light
    }

}
