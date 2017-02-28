//
//  PictureWorker.swift
//  TumblrFinder
//
//  Created by Vlad Krut on 27.02.17.
//  Copyright © 2017 Vlad Krut. All rights reserved.
//

import Foundation
import UIKit

class PictureWorker {
    
    private let tumblrAPIHost = "http://api.tumblr.com/v2/tagged"
    private let APIKey = "CcEqqSrYdQ5qTHFWssSMof4tPZ89sfx6AXYNQ4eoXHMgPJE03U"
    
    private let responseKey = "response"
    private let blogNameKey = "blog_name"
    private let typeKey = "key"
    private let photosKey = "photos"
    private let altSizesKey = "alt_sizes"
    private let widthKey = "width"
    private let heightKey = "height"
    private let photoURLKey = "url"
    
    
    open func searchWithTag(_ tag: String, withCompletionHandler handler:@escaping (([Post], NetworkError?) -> Void)) {
        let convertedTag = tag.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let stringURL = "\(tumblrAPIHost)?tag=\(convertedTag!)&api_key=\(APIKey)"
        let url = URL(string: stringURL)!
        let session = URLSession.shared
        
        var fetchedPosts = [Post]()
        var fetchingError: NetworkError? = nil
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            guard error == nil else {
                fetchingError = NetworkError.invalidRequest
                handler(fetchedPosts, fetchingError)
                return
            }
            
            let rawJSON: Any
            do {
                rawJSON = try JSONSerialization.jsonObject(with: data!)
            } catch {
                fetchingError = NetworkError.JSONParsingError
                handler(fetchedPosts, fetchingError)
                return
            }
            
            guard let rawDictionary = rawJSON as? Dictionary<String, Any> else {
                fetchingError = NetworkError.JSONParsingError
                handler(fetchedPosts, fetchingError)
                return
            }
            
            guard rawDictionary[self.responseKey] != nil else {
                fetchingError = NetworkError.JSONParsingError
                handler(fetchedPosts, fetchingError)
                return
            }
            
            guard let postsArray = rawDictionary[self.responseKey] as? [Dictionary<String, Any>] else {
                fetchingError = NetworkError.JSONParsingError
                handler(fetchedPosts, fetchingError)
                return
            }
          
            for postDictionary in postsArray {
                
                guard postDictionary[self.typeKey] as? String != "photo" else {
                    continue
                }
                
                guard let photosArray = postDictionary[self.photosKey] as? [Dictionary<String, Any>] else {
                    continue
                }
                
                guard let blogName = postDictionary[self.blogNameKey] as? String else {
                    continue
                }
                
                for photoDictionary in photosArray {
                    
                    guard let altSizesArray = photoDictionary[self.altSizesKey] as? [Dictionary<String, Any>] else {
                        continue
                    }
                    
                    guard let photoURL = altSizesArray.first?[self.photoURLKey] as? String,
                        let photoWidth = altSizesArray.first?[self.widthKey] as? Int,
                        let photoHeight = altSizesArray.first?[self.heightKey] as? Int else {
                            continue
                    }
                    let post = Post(from: blogName, withImageSize: CGSize(width: photoWidth, height: photoHeight), imageURL: photoURL)
                    fetchedPosts.append(post)
                }
            }
            
            handler(fetchedPosts, fetchingError)
        })
        
        task.resume()
    }
    
    open func fetchImage(from url: String, withCompletionHandler handler:@escaping ((UIImage?, NetworkError?) -> Void)) {
        
        var error: NetworkError? = nil
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: URL(string: url)!)
            
            guard data != nil else {
                error = NetworkError.imageDataNotFetched
                handler(nil, error)
                return
            }
            
            guard let image = UIImage(data: data!) else {
                error = NetworkError.invalidImageData
                handler(nil, error)
                return
            }
            
            handler(image, error)
        }
    }
    
    
}
