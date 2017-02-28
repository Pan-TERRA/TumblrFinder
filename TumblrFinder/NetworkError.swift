//
//  NetworkError.swift
//  TumblrFinder
//
//  Created by Vlad Krut on 27.02.17.
//  Copyright © 2017 Vlad Krut. All rights reserved.
//

import Foundation

enum NetworkError : Error {
    case invalidRequest
    case serverDoesNotRespond
    case invalidResponse
    case JSONParsingError
    case imageDataNotFetched
    case invalidImageData
    
    var description: String {
        switch self {
        case .invalidRequest: return "Invalid request"
        case .serverDoesNotRespond: return "Server does not respond"
        case .invalidResponse: return "Invalid response"
        case .JSONParsingError: return "JSON parsing error"
        case .imageDataNotFetched: return "Image fetching failed"
        case .invalidImageData: return "Invalid image"
        }
    }
}
