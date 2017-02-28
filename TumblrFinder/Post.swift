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
    open let imageSize: CGSize
    open let imageURL: String
    open var image: UIImage? {
        didSet {
            miniature = image?.imageResizeTo(width: Post.miniatureWidth)
        }
    }
    open var miniature: UIImage?
    open var imageFetchingInProgress = false
    
    init(from blogName: String, withImageSize size: CGSize, imageURL url: String) {
        self.blogName = blogName
        self.imageSize = size;
        self.imageURL = url;
    }
}
