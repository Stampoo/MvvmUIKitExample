//
//  UIImage.swift
//  
//
//  Created by Князьков Илья on 03.05.2022.
//

import UIKit

public extension UIImage {

    class func solidColor(_ color: UIColor) -> UIImage? {
        let size = CGSize(width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(size, false, .zero)
        color.setFill()
        UIRectFill(CGRect(origin: CGPoint.zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

}
