//
//  C.swift
//  RequiredProperty
//
//  Created by sykang on 2023/03/06.
//

import Foundation

struct C {
  var aList: [A] = []
  var bList: [B] = []
  var aListOp: [A]?
  var bListOp: [B]?
}

extension C: RequiredProperty {
  var keys: [String] {
    ["aList", "bList", "aListOp", "bListOp"]
  }
}
