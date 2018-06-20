//
//  Item.swift
//  Todoey
//
//  Created by Josh Davis on 6/19/18.
//  Copyright © 2018 Josh Davis. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title = ""
    @objc dynamic var isDone = false
    @objc dynamic var dateCreated: Date?
 
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
