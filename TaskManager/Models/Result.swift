//
//  Result.swift
//  TaskManager
//
//  Created by Alireza Asadi on 21/5/1398 AP.
//  Copyright © 1398 AP MrAlirezaa. All rights reserved.
//

import Foundation

enum Result<Success, Failure> {
    case success(Success)
    case failure(Failure)
}
