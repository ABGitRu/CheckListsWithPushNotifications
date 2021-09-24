//
//  Checklist.swift
//  CheckListsWithPushNotifications
//
//  Created by Mac on 22.09.2021.
//

import Foundation

class Checklist: NSObject, Codable {
    var name: String
    var items: [ChecklistItem] = []
    var iconName = "No Icon"
    
    init(name: String, iconName: String = "No Icon") {
        self.name = name
        self.iconName = iconName
    }
    
    func countUncheckedItems() -> Int {
        var count = 0
        for item in items {
            if !item.checked {
               count += 1
            }
        }
        return count
    }
}
