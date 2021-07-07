//
//  RestHandler.swift
//  Puzzle Game
//
//  Created by Simon Enström on 2018-11-26.
//  Copyright © 2018 Goobers. All rights reserved.
//

import Foundation

class RestHandler {
    
    static private let API_PATH: String = "https://picsum.photos/"
    static private let API_PEOPLE: String = "list/"
    
    static func getImages(completion: ((Bool) -> Void)?) {
        guard let url = URL(string: API_PATH + API_PEOPLE) else {
            completion?(false)
            return
        }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            let decoder = JSONDecoder()
            if let data = responseData {
                let result = try? decoder.decode([ImagesAPI].self, from: data)	
                DataHandler.instance._images = result!
                completion?(true)
            } else {
                completion?(false)
                
            }
        }
        task.resume()
    }
}
