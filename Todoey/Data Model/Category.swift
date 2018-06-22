//
//  Category.swift
//  Todoey
//
//  Created by Josh Davis on 6/19/18.
//  Copyright © 2018 Josh Davis. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var cellColor = ""
    
    let items = List<Item>()
    
}
