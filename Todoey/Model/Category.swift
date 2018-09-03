//
//  Category.swift
//  Todoey
//
//  Created by MD Monir Hossan on 8/27/18.
//  Copyright © 2018 MD Monir Hossan. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
