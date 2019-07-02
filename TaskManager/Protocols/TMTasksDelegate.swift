//
//  TMTasksDelegate.swift
//  TaskManager
//
//  Created by Alireza Asadi on 5/4/1398 AP.
//  Copyright © 1398 AP MrAlirezaa. All rights reserved.
//

import Foundation

protocol TMTasksDelegate {
    func tasksChanged(_ dataSource: TMTasksDataSource)
}
