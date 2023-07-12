//
//  Image+Extension.swift
//  CodeTest
//
//  Created by Alex on 12/7/2023.
//

import UIKit

extension UIImage {
    
    func imageWithColor( _ color:UIColor) -> UIImage? {

    UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)

    let context = UIGraphicsGetCurrentContext()

    context?.translateBy(x: 0, y: self.size.height)

    context?.scaleBy(x: 1.0, y: -1.0)

    context?.setBlendMode(CGBlendMode.normal)

    let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)

    context?.clip(to: rect, mask: self.cgImage!)

    color.setFill()

    context?.fill(rect)

    let newImage = UIGraphicsGetImageFromCurrentImageContext()

    UIGraphicsEndImageContext()

    return newImage

    }
}
