
//
//  API.swift
//  NameGame
//
//  Created by Matt Kauper on 3/10/16.
//  Copyright © 2016 WillowTree Apps. All rights reserved.
//

import Foundation
import UIKit

open class API {

    private static let dataURL: String = "https://www.willowtreeapps.com/api/v1.0/profiles"
    
    static func getProfiles(_ completion: @escaping ([Profile]?, Error?) -> Void) {
        let requestURL: URL = URL(string: dataURL)!
        let task = URLSession.shared.dataTask(with: requestURL, completionHandler: {
            (data, response, error) -> Void in

            guard let httpResponse = response as? HTTPURLResponse, error == nil, httpResponse.statusCode == 200, let data = data else {
                completion(nil, error)
                return
            }

            do {
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([Profile].self, from: data)
                completion(jsonData, nil)
            } catch let error as NSError {
                NSLog("JSON Parsing error: \(error)")
                completion(nil, error)
            }
        })
        task.resume()
    }
}
