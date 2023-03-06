//
//  RequiredProperty.swift
//  RequiredProperty
//
//  Created by sykang on 2023/03/03.
//

import Foundation

public enum RequiredPropertyErrorType: Equatable, CustomStringConvertible {
  case isNil
  case isEmpty
  case invalidKey

  public var description: String {
    switch self {
    case .isNil:
      return "is Nil"
    case .isEmpty:
      return "is Empty"
    case .invalidKey:
      return "is invalid"
    }
  }
}

protocol RequiredProperty {
  typealias Result = [String: RequiredPropertyErrorType]
  var keys: [String] {get}
}

extension RequiredProperty {
  func checkRequiredProperty() -> Result? {
    let mirror = Mirror(reflecting: self)
    var result = Result()
    
    for key in keys {
      guard let target = mirror.descendant(key) else {
        result[key] = .invalidKey
        continue
      }
      switch target {
      case Optional<Any>.none:
        result[key] = .isNil
        continue
      case let value as String, Optional<String>.some(let value):
        RequiredPropertyChecker<String>().check(value, key: key, result: &result)
        continue
      case let value as RequiredProperty, Optional<RequiredProperty>.some(let value):
        RequiredPropertyChecker<RequiredProperty>().check(value, key: key, result: &result)
        continue
      case let value as Array<Any>, Optional<Array<Any>>.some(let value):
        RequiredPropertyChecker<Array<Any>>().check(value, key: key, result: &result)
        continue
      default:
        break
      }
    }
    
    return result.isEmpty ? nil : result
  }
}
