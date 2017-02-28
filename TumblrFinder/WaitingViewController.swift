//
//  WaitingViewController.swift
//  TumblrFinder
//
//  Created by Vlad Krut on 28.02.17.
//  Copyright © 2017 Vlad Krut. All rights reserved.
//

import UIKit

class WaitingViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.startAnimating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        activityIndicator.stopAnimating()
    }
}
