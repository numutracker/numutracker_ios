//
//  SearchClient.swift
//  Numu Tracker
//
//  Created by Bradley Root on 8/28/16.
//  Copyright © 2016 Amiantos. All rights reserved.
//

import Foundation
import SwiftyJSON

class SearchClient {

    static let sharedClient = SearchClient()

    func HTTPsendRequest(request: NSMutableURLRequest,
                         callback: @escaping (String, String?) -> Void) {
        let task = URLSession.shared
            .dataTask(with: request as URLRequest) {
                (data, response, error) -> Void in
                if error != nil {
                    callback("", error?.localizedDescription)
                } else {
                    callback(String(data: data!, encoding: .utf8)!, nil)
                }
        }

        task.resume()
    }

    func HTTPPostJSON(url: String,  data: NSData,
    callback: @escaping (String, String?) -> Void) {

        let request = NSMutableURLRequest(url: URL(string: url)!)

        request.httpMethod = "POST"
        request.addValue("application/json",forHTTPHeaderField: "Content-Type")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
        request.httpBody = data as Data
        HTTPsendRequest(request: request, callback: callback)
    }

}
