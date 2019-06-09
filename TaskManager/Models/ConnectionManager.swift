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
    
    
    func login(username: String, password: String, onSuccess: @escaping (Result<User, Error>) -> ()) {
        let session = URLSession.shared
        
        let loginURL = URL(string: "http://buzztaab.com:8081/api/login")!
        var request = URLRequest(url: loginURL)
        request.httpMethod = "post"

        request.timeoutInterval = 20
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: Parameteres = ["email" : username, "password": password]
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        
        session.dataTask(with: request) { (data: Data?, urlResponse: URLResponse?, error: Error?) in
            if let error = error {
                onSuccess(.failure(error))
                return
            }
            var user: User?
            var apiError: Error?
            if let data = data {
                do {
                    let jsonObject = try (JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : Any])
                    print("Initial Serialization.")
                    print("Code is: \(jsonObject["code"] as! Int)")
                    if jsonObject["code"] as! Int == 200 {
                        let body = (jsonObject["body"] as! [String : Any])
                        let newJson = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        
                        user = try? decoder.decode(User.self, from: newJson!)
                        print("user in dataTask:\(user!)")
                        
                        if let user = user {
                            onSuccess(.success(user))
                        }
                    } else if jsonObject["code"] as! Int == -1 {
                        apiError = TMError.notFound
                        onSuccess(.failure(apiError!))
                    }
                } catch let err {
                    print("error in serialization: \(err.localizedDescription)")
                    onSuccess(.failure(err))
                }
            }
        }.resume()
    }
    
    func register(withEmail email: String, password: String, onSuccess: (Result<User, Error>) -> ()) {
        
    }
}

enum TMError: LocalizedError {
    case notFound
}
