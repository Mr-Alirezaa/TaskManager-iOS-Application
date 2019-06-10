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
    
    private typealias JSONDictionary = [String : Any]
    
    
    // MARK: - Login & Registration.
    
    func login(username: String, password: String, onSuccess: @escaping (Result<User, Error>) -> ()) {
        let session = URLSession.shared
        
        let loginURL = URL(string: "http://buzztaab.com:8081/api/login")!
        var request = URLRequest(url: loginURL)
        request.httpMethod = "post"

        request.timeoutInterval = 20
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: JSONDictionary = ["email" : username, "password": password]
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        
        session.dataTask(with: request) { (data: Data?, urlResponse: URLResponse?, error: Error?) in
            if let error = error {
                onSuccess(.failure(error))
                return
            }
            
            var user: User?
            var token: String?
            var apiError: Error?
            
            if let response = urlResponse as? HTTPURLResponse {
                let header = response.allHeaderFields
                if let headerToken = header["token"] {
                    token = headerToken as? String
                    token = "Bearer " + (token ?? "")
                }
            }
            
            if let data = data {
                do {
                    let jsonObject = try (JSONSerialization.jsonObject(with: data, options: .allowFragments) as! JSONDictionary)
                    if jsonObject["code"] as! Int == 200 {
                        let body = (jsonObject["body"] as! JSONDictionary)
                        let newJson = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
                        
                        let decoder = JSONDecoder()
                        user = try? decoder.decode(User.self, from: newJson!)
                        
                        if var user = user {
                            if let token = token {
                                user.token = token
                            }
                            onSuccess(.success(user))
                        }
                    } else if jsonObject["code"] as! Int == -1 {
                        apiError = TMError.SignInError.userNotFound
                        onSuccess(.failure(apiError!))
                    }
                } catch let err {
                    print("error in serialization: \(err.localizedDescription)")
                    onSuccess(.failure(err))
                }
            }
        }.resume()
    }
    
    func register(user: User, onSuccess: @escaping (Result<User, Error>) -> ()) {
        let session = URLSession.shared
        let registerURL: URL! = URL(string: "http://buzztaab.com:8081/api/register")
        
        var request = URLRequest(url: registerURL)
        request.timeoutInterval = 20
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "post"
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let body = try? encoder.encode(user)
        
        request.httpBody = body
        
        session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                onSuccess(.failure(error))
                return
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! JSONDictionary
                    var code = json["code"] as? Int
                    if code == nil {
                        code = -1
                    }
                    
                    if code == 200 {
                        let body = json["body"] as! JSONDictionary
                        
                        let newJson = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
                        let decoder = JSONDecoder()

                        if let json = newJson {
                            let user = try? decoder.decode(User.self, from: json)
                            
                            onSuccess(.success(user!))
                        }
                    } else if code == -1 {
                        if let message = json["message"] as? String {
                            if message == "Validation error: لطفا ایمیل معتبر وارد کنید" {
                                onSuccess(.failure(TMError.SignUpError.invalidEmailAddress))
                            } else if message == "این ایمیل قبلا ثبت شده" {
                                onSuccess(.failure(TMError.SignUpError.userAlreadyRegistered))
                            }
                        }
                    }
                } catch let parseError {
                    onSuccess(.failure(parseError))
                    return
                }
            }
        }.resume()
    }
    
    // MARK: - Manage Task Groups.
    
    func fetchTaskGroups(for user: User, onSuccess: @escaping (Result<[TMTaskGroup], Error>) -> ()) {
        let session = URLSession.shared
        
        let getTaskURL = URL(string: "http://buzztaab.com:8081/api/getGroup/")!
        
        var request = URLRequest(url: getTaskURL)
        request.timeoutInterval = 20
        request.httpMethod = "post"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue(UserDefaults.standard.string(forKey: TMUserDefualtsKeys.apiToken)!, forHTTPHeaderField: "authorization")
        let test = user.token!
        request.addValue(test, forHTTPHeaderField: "authorization")
        
        session.dataTask(with: request) { (data, urlResponse, error) in
            if let error = error {
                onSuccess(.failure(error))
                return
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! JSONDictionary
                    
                    if json["code"] as! Int == 200 {
                        let body = json["body"] as! [Any]
                        var taskGroups = [TMTaskGroup]()
                        let decoder = JSONDecoder()

                        for item in body {
                            let newJson = try! JSONSerialization.data(withJSONObject: item, options: .prettyPrinted)
                            let taskGroup = try? decoder.decode(TMTaskGroup.self, from: newJson)
                            if let taskGroup = taskGroup {
                                taskGroups += [taskGroup]
                            }
                        }
                        onSuccess(.success(taskGroups))
                    }
                    
                } catch let parseError {
                    print(parseError)
                }
            }
            
        }.resume()
    }
    
    func deleteTaskGroup(taskGroup: TMTaskGroup, onSuccess: @escaping (Result<TMTaskGroup, Error>) -> ()) {
        let session = URLSession.shared
        
        let destinationURL = URL(string: "http://buzztaab.com:8081/api/deleteGroup/")!
        
        var request = URLRequest(url: destinationURL)
        request.timeoutInterval = 20
        request.httpMethod = "post"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(UserDefaults.standard.string(forKey: TMUserDefualtsKeys.apiToken)!, forHTTPHeaderField: "authorization")
        
        let body: JSONDictionary = ["group_id" : taskGroup.id]
        let jsonBody = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        request.httpBody = jsonBody
        
        session.dataTask(with: request) { (data, urlResponse, error) in
            if let error = error {
                onSuccess(.failure(error))
                return
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! JSONDictionary
                    if json["code"] as! Int == 200 {
                        onSuccess(.success(taskGroup))
                    } else {
                        onSuccess(.failure(TMError.DeleteTaskGroup.somethingWentWrong))
                    }
                } catch let parseError {
                    onSuccess(.failure(parseError))
                    return
                }
            }
            
        }.resume()

    }
    
    func editTaskGroupName(taskGroup: TMTaskGroup, to name: String, onSuccess: @escaping (Result<TMTaskGroup, Error>) -> ()) {
        let session = URLSession.shared
        
        let destinationURL = URL(string: "http://buzztaab.com:8081/api/deleteGroup/")!
        
        var request = URLRequest(url: destinationURL)
        request.timeoutInterval = 20
        request.httpMethod = "post"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(UserDefaults.standard.string(forKey: TMUserDefualtsKeys.apiToken)!, forHTTPHeaderField: "authorization")
        
        let body: JSONDictionary = ["group_id" : taskGroup.id, "groupName" : name]
        let jsonBody = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        request.httpBody = jsonBody
        
        session.dataTask(with: request) { (data, urlResponse, error) in
            if let error = error {
                onSuccess(.failure(error))
                return
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! JSONDictionary
                    let code = json["code"] as? Int
                    
                    if code == 200 {
                        
                    } else {
                        
                    }
                } catch let parseError {
                    onSuccess(.failure(parseError))
                    return
                }
            }
            
        }
    }
    
    func createTaskGroup(taskGroup: TMTaskGroup, onSuccess: @escaping (Result<TMTaskGroup, Error>) -> ()) {
        let session = URLSession.shared
        
        let destinationURL = URL(string: "http://buzztaab.com:8081/api/deleteGroup/")!
        
        var request = URLRequest(url: destinationURL)
        request.timeoutInterval = 20
        request.httpMethod = "post"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(UserDefaults.standard.string(forKey: TMUserDefualtsKeys.apiToken)!, forHTTPHeaderField: "authorization")
        
        let body: JSONDictionary = ["group_id" : taskGroup.id, "groupName" : taskGroup.name]
        let jsonBody = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        request.httpBody = jsonBody
        
        session.dataTask(with: request) { (data, urlResponse, error) in
            if let error = error {
                onSuccess(.failure(error))
                return
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! JSONDictionary
                    let code = json["code"] as? Int
                    
                    if code == 200 {
                        
                    } else {
                        
                    }
                } catch let parseError {
                    onSuccess(.failure(parseError))
                    return
                }
            }
            
        }
    }
    
    // MARK: - Manage Tasks
}

enum TMError: LocalizedError {
    case notFound
    
    enum SignUpError: LocalizedError {
        case userAlreadyRegistered
        case invalidEmailAddress
    }
    
    enum SignInError: LocalizedError {
        case userNotFound
    }
    
    enum DeleteTaskGroup: LocalizedError {
        case somethingWentWrong
    }
}


