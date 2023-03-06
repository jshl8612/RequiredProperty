//
//  A.swift
//  RequiredProperty
//
//  Created by sykang on 2023/03/06.
//

import Foundation

struct A {
  var name: String?
  var age: Int = 0
  var address: String = ""
  var b: B?
  var bList: [B] = []
  var bListOptional: [B]?
}

extension A: RequiredProperty {
  
  var keys: [String] {
    ["name", "age", "address", "b"]
  }
}
