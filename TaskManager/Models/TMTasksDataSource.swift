//
//  TMTasksDataSource.swift
//  TaskManager
//
//  Created by Alireza Asadi on 5/4/1398 AP.
//  Copyright © 1398 AP MrAlirezaa. All rights reserved.
//

import Foundation

public class TMTasksDataSource {

    public static var shared = TMTasksDataSource()

    private init() {
        
    }

    private var tasks = [TMTask]()
}
