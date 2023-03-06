//
//  RequiredPropertyChecker.swift
//  RequiredProperty
//
//  Created by sykang on 2023/03/06.
//

import Foundation

protocol RequiredPropertyCheckerProtocol {
  associatedtype T
}

struct RequiredPropertyChecker<T>: RequiredPropertyCheckerProtocol {}

extension RequiredPropertyCheckerProtocol where T == String {
  func check(_ value: T, key: String, result: inout RequiredProperty.Result) {
    if value.isEmpty {
      result[key] = .isEmpty
    }
  }
}

extension RequiredPropertyCheckerProtocol where T == RequiredProperty {
  func check(_ value: T, key: String, result: inout RequiredProperty.Result) {
    if let errorResult = value.checkRequiredProperty() {
      result.merge(errorResult.map({("\(key).\($0.key)", $0.value)}), uniquingKeysWith: { (_, new) in new })
    }
  }
}

extension RequiredPropertyCheckerProtocol where T == Array<Any> {
  func check(_ value: T, key: String, result: inout RequiredProperty.Result) {
    if value.isEmpty {
      result[key] = .isEmpty
      return
    }
    
    if let stringArray = value as? Array<String>, let first = stringArray.first {
      RequiredPropertyChecker<String>().check(first, key: "\(key).0", result: &result)
      return
    }
    
    if let requiredArray = value as? Array<RequiredProperty>, let first = requiredArray.first {
      RequiredPropertyChecker<RequiredProperty>().check(first, key: "\(key).0", result: &result)
      return
    }
  }
}
