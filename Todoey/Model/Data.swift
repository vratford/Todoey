//
//  Data.swift
//  Todoey
//
//  Created by Vincent Ratford on 3/8/18.
//  Copyright © 2018 Vincent Ratford. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var age: Int = 0
    
}
