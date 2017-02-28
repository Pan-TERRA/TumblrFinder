//
//  Post.swift
//  TumblrFinder
//
//  Created by Vlad Krut on 27.02.17.
//  Copyright © 2017 Vlad Krut. All rights reserved.
//

import Foundation
import UIKit

class Post {
    
    private static let miniatureWidth: CGFloat = 300.0
    
    open let blogName: String
    open let image: UIImage?
    open let miniature: UIImage?
    
    init(from blogName: String, with image: UIImage?) {
        self.blogName = blogName
        self.image = image
        self.miniature = image?.imageResizeTo(width: Post.miniatureWidth)
    }
    
    convenience init(from blogName: String) {
        self.init(from: blogName, with: nil)
    }
    
}
