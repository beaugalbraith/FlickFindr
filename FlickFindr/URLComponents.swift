//
//  URLComponents.swift
//  FlickFindr
//
//  Created by gem on 7/18/17.
//  Copyright © 2017 beau. All rights reserved.
//

import Foundation

class Helpers {
    
    init() {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.flickr.com"
        components.path = "/services/rest"
        components.queryItems = {
            var queryItems = [URLQueryItem]()
            let queryItemOne = URLQueryItem(name: "specifier", value: "flickr.photos.search")
            let queryItemTwo = URLQueryItem(name: "api_key", value: APIKEY)
            let queryItemThree = URLQueryItem(name: "text", value: "purple")
            queryItems.append(queryItemOne)
            queryItems.append(queryItemTwo)
            queryItems.append(queryItemThree)
            return queryItems
        }()
        print(components.url!)
    }
}
