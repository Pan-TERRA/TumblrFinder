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
    
    open var gallery: Gallery?
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(PictureTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.register(UINib(nibName: "PictureTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gallery?.posts.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        let pictureCell = cell as! PictureTableViewCell
        
        pictureCell.pictureView?.image = gallery?.posts[indexPath.item].miniature

        return pictureCell
    }
    
    // MARK: - Table View Delegate

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {        let height = gallery?.posts[indexPath.item].miniature?.size.height
        return height ?? 100.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let storybord = UIStoryboard(name: "Main", bundle: nil)
        let postViewController = storybord.instantiateViewController(withIdentifier: "postViewController") as! PostViewController
        postViewController.post = gallery?.posts[indexPath.item]
        
        self.navigationController?.pushViewController(postViewController, animated: true)
    }
}
