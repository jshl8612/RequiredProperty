//
//  B.swift
//  RequiredProperty
//
//  Created by sykang on 2023/03/06.
//

import Foundation

class B {
  var name: String?
  var age: Int = 0
}
extension B: RequiredProperty {
  var keys: [String] {
    ["name", "age"]
  }
}
