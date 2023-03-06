//
//  RequiredProperty.swift
//  RequiredProperty
//
//  Created by sykang on 2023/03/03.
//

import Foundation

enum RequiredPropertyResult {
  case valid
  case invalid(String)
  
  mutating func appendInvalid(_ errorMsg: String) {
    switch self {
    case .valid:
      self = RequiredPropertyResult.invalid("\(errorMsg)")
    case .invalid(let msg):
      self = RequiredPropertyResult.invalid(msg+", "+errorMsg)
    }
  }
}

extension RequiredPropertyResult: Equatable {
  static func == (lhs: RequiredPropertyResult, rhs: RequiredPropertyResult) -> Bool {
    switch (lhs, rhs) {
    case (.invalid(let lMsg), .invalid(let rMsg)):
      return lMsg == rMsg
    case (.valid, .valid):
      return true
    default:
      return false
    }
  }
}

protocol RequiredProperty {
    var keys: [String] {get}
}
extension RequiredProperty {
  
  func checkRequiredProperty() -> RequiredPropertyResult {
    let mirror = Mirror(reflecting: self)
    var result = RequiredPropertyResult.valid
    
    for key in keys {
      guard let target = mirror.descendant(key) else {
        result.appendInvalid(key)
        continue
      }
      
      switch target {
      case let value as String:
        if value.isEmpty {
          result.appendInvalid(key)
        }
        continue
      case let value as RequiredProperty:
        if case RequiredPropertyResult.invalid(let property) = value.checkRequiredProperty() {
          result.appendInvalid("\(key).\(property)")
        }
        continue
      case Optional<Any>.none:
        result.appendInvalid("\(key)")
        continue
      case Optional<String>.some(let value):
        if value.isEmpty {
          result.appendInvalid(key)
        }
        continue
      case Optional<RequiredProperty>.some(let value):
        if case RequiredPropertyResult.invalid(let property) = value.checkRequiredProperty() {
          result.appendInvalid("\(key).\(property)")
        }
        continue
      default:
        break
      }
    }
    return result
  }
}
