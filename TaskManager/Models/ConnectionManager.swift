//
//  ConnectionManager.swift
//  TaskManager
//
//  Created by Alireza Asadi on 29/2/1398 AP.
//  Copyright © 1398 AP MrAlirezaa. All rights reserved.
//

import Foundation

public struct ConnectionManager {
    
    public static let `default` = ConnectionManager()
    
    private init() {
        
    }
    
    private typealias Parameteres = [String : Any]
    
    
    public func login(username: String, password: String, onSuccess: @escaping ([String : Any]) -> Void) {
        let session = URLSession.shared
        
        let loginURL = URL(string: "http://buzztaab.com:8081/api/login")!
        var request = URLRequest(url: loginURL)
        request.httpMethod = "post"

        request.timeoutInterval = 20
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: Parameteres = ["email" : username, "password": password]
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        
        session.dataTask(with: request) { (data: Data?, urlResponse: URLResponse?, error: Error?) in
            if let data = data {
                do {
                    let jsonObject = try (JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : Any])
                    let body = jsonObject["body"] as! [String : Any]
                    onSuccess(body)
                } catch let err {
                    print(err)
                }
            }
        }.resume()
        
    }
}
