//
//  SearchViewController.swift
//  TumblrFinder
//
//  Created by Vlad Krut on 27.02.17.
//  Copyright © 2017 Vlad Krut. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet private weak var searchBar: UISearchBar!
    
    private let worker = PictureWorker()
    
    private let waitingViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "waitingViewController")
    
    // MARK: - View Controller Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchBar.becomeFirstResponder()
    }
    
    // MARK: - Actions
    
    @IBAction private func searchButtonOnClick(_ sender: UIButton) {
        if let searchTag = searchBar.text {
            
            guard !searchTag.isEmpty else {
                return
            }
            
            setViewToWaintingState(true)
            
            worker.searchWithTag(searchTag, withCompletionHandler: { posts, error in
                DispatchQueue.main.async {
                    self.setViewToWaintingState(false)
                    
                    if error != nil {
                        
                        let alert = UIAlertController(title: "Error", message: error!.description, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    } else if posts.isEmpty {
                        
                        let alert = UIAlertController(title: "Nothing not found", message: "Look for something else", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                    } else {
                        
                        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                        let galleryViewController = storyboard.instantiateViewController(withIdentifier: "galleryViewController") as! GalleryTableViewController
                        galleryViewController.gallery = Gallery(withPosts: posts)
                        galleryViewController.navigationItem.title = searchTag
                        self.navigationController?.pushViewController(galleryViewController, animated: true)
                    }
                }
            })
        }
    }
    
    private func setViewToWaintingState(_ state: Bool) {
        if state {
            addChildViewController(waitingViewController)
            view.addSubview(waitingViewController.view)
        } else {
            waitingViewController.view.removeFromSuperview()
            waitingViewController.removeFromParentViewController()
        }
    }
    
}

