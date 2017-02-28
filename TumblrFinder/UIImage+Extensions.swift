//
//  UIImage+Extensions.swift
//  TumblrFinder
//
//  Created by Vlad Krut on 27.02.17.
//  Copyright © 2017 Vlad Krut. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    open func imageResize(sizeChange: CGSize) -> UIImage {
        
        let hasAlpha = true
        let scale: CGFloat = 0.0
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }
    
    open func imageResizeTo(width: CGFloat) -> UIImage {
        let aspectRatio = size.width / width
        let newHeight = size.height / aspectRatio
        return imageResize(sizeChange: CGSize(width: width, height: newHeight))
    }

}
