//
//  Data.swift
//  Todoey
//
//  Created by MD Monir Hossan on 8/20/18.
//  Copyright © 2018 MD Monir Hossan. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
