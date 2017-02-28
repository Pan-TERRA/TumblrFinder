//
//  Gallery.swift
//  TumblrFinder
//
//  Created by Vlad Krut on 27.02.17.
//  Copyright © 2017 Vlad Krut. All rights reserved.
//

import Foundation

class Gallery {
    
    open let posts: [Post]
    
    init(withPosts posts: [Post]) {
        self.posts = posts
    }
}
