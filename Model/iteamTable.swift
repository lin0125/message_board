//
//  iteamTable.swift
//  realmtest
//
//  Created by imac-2437 on 2023/7/12.
//
import RealmSwift
import Foundation
class iteamTable: Object {
    @Persisted(primaryKey: true) var uuid: ObjectId
    @Persisted var name: String = ""
    @Persisted var content: String = ""
    @Persisted var timeStamp: Int

    convenience init(name: String ,content: String, timeStamp: Int) {
        self.init()
        self.name = name
        self.content = content
        self.timeStamp = timeStamp
   }
}

struct IteamTable{
    
    var name: String
    
    var content: String
    
    var timeStamp: Int
    
    var uuid: ObjectId
    
}
