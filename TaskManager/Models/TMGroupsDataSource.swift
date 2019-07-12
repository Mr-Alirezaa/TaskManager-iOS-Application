//
//  TMGroupsDataSource.swift
//  TaskManager
//
//  Created by Alireza Asadi on 16/4/1398 AP.
//  Copyright © 1398 AP MrAlirezaa. All rights reserved.
//

import Foundation
import UIKit

protocol TMGroupsDataSourceDelegate {
    func groupsUpdated(_ dataSource: TMGroupsDataSource)
}

public class TMGroupsDataSource: NSObject {
    private var groups = [TMTaskGroup]()

    var selectedRow: Int?
    var selectedGroup: TMTaskGroup?

    private let connectionManager = ConnectionManager.default

    var delegate: TMGroupsDataSourceDelegate?

    init(withPreCheckedGroup group: TMTaskGroup) {
        super.init()

        self.selectedGroup = group
        fetchGroups()
    }

    private func fetchGroups() {
        connectionManager.fetchTaskGroups { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let groups):
                    self.groups = groups

                    if self.selectedRow == nil, let selectedGroup = self.selectedGroup {
                        let index = self.groups.firstIndex { (group) -> Bool in
                            return group == selectedGroup
                        }
                        if let index = index {
                            self.selectedRow = index
                        }
                    }
                    self.delegate?.groupsUpdated(self)
                case .failure(_):
                    break
                }
            }
        }
    }

    public func setSelectedGroup(indexPath: IndexPath) {
        if selectedRow != indexPath.row {
            selectedRow = indexPath.row
            selectedGroup = groups[indexPath.row]
        } else {
            selectedRow = nil
            selectedGroup = nil
        }
    }
}

extension TMGroupsDataSource: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "groups-in-new-task") {
            cell.accessoryType = (indexPath.row == selectedRow) ? .checkmark : .none
            let group = groups[indexPath.row]
            cell.textLabel?.text = group.name
            return cell
        }
        return UITableViewCell()
    }


}


