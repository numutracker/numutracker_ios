//
//  FetchOperation.swift
//  Numu Tracker
//
//  Created by Brad Root on 9/23/18.
//  Copyright © 2018 Numu Tracker. All rights reserved.
//

import Foundation
import SwiftyJSON

final class FetchOperation: AsyncOperation {
    
    private(set) var dataFetched: Data?
    
    private let session = URLSession(configuration: .default)
    private var dataTask: URLSessionDataTask?
    private var url: String
    public var json: JSON
    
    init(_ url: String) {
        self.url = url
        self.json = JSON.null
    }
    
    override func main() {
        
        let url = URL(string: self.url)!
        dataTask = session.dataTask(with: url) {[unowned self] (data, _, _) in
            guard let data = data else { return }
            
            do {
                self.json = try JSON(data: data)
            } catch {
                self.json = JSON.null
                //print(error.localizedDescription)
            }

            self.state = .isFinished
        }
        dataTask?.resume()
    }
}
