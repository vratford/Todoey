//
//  Item.swift
//  Todoey
//
//  Created by Vincent Ratford on 3/8/18.
//  Copyright © 2018 Vincent Ratford. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated : Date?
//    @objc dynamic var cellColor : String = ""
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items") // reverse relationship Item to Category
    
}
