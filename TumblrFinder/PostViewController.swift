//
//  PostViewController.swift
//  TumblrFinder
//
//  Created by Vlad Krut on 28.02.17.
//  Copyright © 2017 Vlad Krut. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

    @IBOutlet private weak var imageView: UIImageView!
    
    open var post: Post?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard post != nil else {
            return
        }
        navigationItem.title = post!.blogName
        imageView.image = post!.image
    }
}
