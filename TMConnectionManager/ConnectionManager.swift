//
//  ConnectionManager.swift
//  TaskManager
//
//  Created by Alireza Asadi on 29/2/1398 AP.
//  Copyright © 1398 AP MrAlirezaa. All rights reserved.
//

import Foundation

struct ConnectionManager {
    
    private typealias Parameteres = [String : Any]
    
    
    func login(username: String, password: String, onSuccess: () -> Void) {
        let session = URLSession.shared
        
        let loginURL = URL(string: "http://buzztaab.com:8081/api/login")!
        var request = URLRequest(url: loginURL)
        request.httpMethod = "get"

        request.timeoutInterval = 20
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: Parameteres = ["email" : username, "password": password]
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        
        session.dataTask(with: request) { (data: Data?, urlResponse: URLResponse?, error: Error?) in
            if let data = data {
                let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print(jsonObject!)
            }
        }.resume()
        
    }
}
