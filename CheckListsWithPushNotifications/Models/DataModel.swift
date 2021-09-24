//
//  DataModel.swift
//  CheckListsWithPushNotifications
//
//  Created by Mac on 22.09.2021.
//

import Foundation

class DataModel {
    var lists = [Checklist]()
    
    var indexOfSelectedChecklist: Int {
      get {
        return UserDefaults.standard.integer(
          forKey: "ChecklistIndex")
      }
      set {
        UserDefaults.standard.set(
          newValue,
          forKey: "ChecklistIndex")
      }
    }
    
    init() {
        loadChecklists()
        registerDegaults()
        handleFirstTime()
    }
    private func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    private func dataFilePath() -> URL {
        documentsDirectory().appendingPathComponent("Checklists.plist")
    }

    private func loadChecklists() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                lists = try decoder.decode([Checklist].self, from: data)
                sortChecklists()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func saveChecklists() {
        let encoder = PropertyListEncoder()

        do {
            let data = try encoder.encode(lists)
            try data.write(to: dataFilePath(), options: .atomic)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func registerDegaults() {
        let dictionary = ["CheckListIndex": -1, "FirstTime": true] as [String : Any]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        
        if firstTime {
            let list = Checklist(name: "List")
            lists.append(list)
            indexOfSelectedChecklist = 0
            userDefaults.set(false, forKey: "FirstTime")
        }
    }
    
    func sortChecklists() {
        lists.sort { list1, list2 in
            return list1.name.localizedStandardCompare(list2.name) == .orderedAscending
        }
    }
    
    class func nextChecklistItemID() -> Int {
        let userDefaults = UserDefaults.standard
        let itemID = userDefaults.integer(forKey: "ChecklistItemID")
        userDefaults.set(itemID + 1, forKey: "ChecklistItemID")
        return itemID
    }
}
