//
//  ViewController.swift
//  Numu Tracker
//
//  Created by Brad Root on 2/5/19.
//  Copyright © 2019 Brad Root. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print(NumuCredential.shared.getV2Details())
        
        NumuCredential.shared.storeCredential(username: "test@test.com", password: "TestingP@ssword")
        
        if let url = URL(string: "https://api.numutracker.com/v3/user") {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let dataResponse = data,
                    error == nil else {
                        print(error?.localizedDescription ?? "Response Error")
                        return
                }
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: dataResponse, options: [])
                    print(jsonResponse)
                } catch let parsingError {
                    print("Error", parsingError)
                }
            }
            task.resume()
        }
        
    }


}

