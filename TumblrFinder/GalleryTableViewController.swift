//
//  GalleryTableViewController.swift
//  TumblrFinder
//
//  Created by Vlad Krut on 27.02.17.
//  Copyright © 2017 Vlad Krut. All rights reserved.
//

import UIKit

class GalleryTableViewController: UITableViewController {
    
    private let reuseIdentifier = "pictureReuseIdentifier"
    private let searchBar = UISearchBar()
    
    private let worker = PictureWorker()
    private var gallery: Gallery?
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(PictureTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.register(UINib(nibName: "PictureTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "endlessBackground"))
        
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if gallery == nil {
            searchBar.becomeFirstResponder()
        }
    }
    
    // MARK: - Actions
    
    fileprivate func searchWith(tag: String) {
        
        worker.searchWithTag(tag, withCompletionHandler: { posts, error in
            DispatchQueue.main.async {
                
                if error != nil {
                    
                    let alert = UIAlertController(title: "Error", message: error!.description, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else if posts.isEmpty {
                    
                    let alert = UIAlertController(title: "Nothing not found", message: "Look for something else", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                    self.gallery = Gallery(withPosts: posts)
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gallery?.posts.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        let pictureCell = cell as! PictureTableViewCell
        
        let post = gallery?.posts[indexPath.item]
        
        
        guard post != nil else {
            return pictureCell
        }
        
        if post!.miniature == nil && !post!.imageFetchingInProgress {
            post!.imageFetchingInProgress = true
            worker.fetchImage(from: post!.imageURL, withCompletionHandler: { (image, error) in
                DispatchQueue.main.async {
                    
                    guard error == nil else {
                        let alert = UIAlertController(title: "Error", message: error!.description, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    
                    if image != nil {
                        post!.image = image
                        post!.imageFetchingInProgress = false
                        pictureCell.pictureView.image = post!.miniature
                    }
                }
            })
        } else {
            pictureCell.pictureView.image = post!.miniature
        }
        
        return pictureCell
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let fullImageSize = (gallery?.posts[indexPath.item].imageSize)!
        
        let aspectRatio = fullImageSize.width / 300.0
        let newHeight = fullImageSize.height / aspectRatio
        
        return newHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let post = gallery?.posts[indexPath.item]
        guard post?.image != nil else {
            return
        }
        
        let storybord = UIStoryboard(name: "Main", bundle: nil)
        let postViewController = storybord.instantiateViewController(withIdentifier: "postViewController") as! PostViewController
        postViewController.post = post
        
        self.navigationController?.pushViewController(postViewController, animated: true)
    }
}

extension GalleryTableViewController: UISearchBarDelegate {
    internal func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchTag = searchBar.text {
            
            guard !searchTag.isEmpty else {
                return
            }
            searchBar.resignFirstResponder()
            searchWith(tag: searchTag)
        }
    }
}

