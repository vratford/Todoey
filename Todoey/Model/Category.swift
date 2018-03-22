//
//  Category.swift
//  Todoey
//
//  Created by Vincent Ratford on 3/8/18.
//  Copyright © 2018 Vincent Ratford. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var cellColor : String = ""
    let items = List<Item>() // forward relationship between Category and Item
    
}
