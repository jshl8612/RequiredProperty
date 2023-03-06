//
//  RequiredPropertyTests.swift
//  RequiredPropertyTests
//
//  Created by sykang on 2023/03/03.
//

import XCTest
@testable import RequiredProperty

final class RequiredPropertyTests: XCTestCase {
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testExample() throws {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    // Any test you write for XCTest can be annotated as throws and async.
    // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
    // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
  }
  
  func testPerformanceExample() throws {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
  func testString() {
    var a = A()
    if let result = a.checkRequiredProperty() {
      XCTAssertEqual(result["name"], .isNil)
      XCTAssertEqual(result["address"], .isEmpty)
      XCTAssertEqual(result["b"], .isNil)
    }
    
    a.name = "ss"
    a.address = "aaaa"
    if let result = a.checkRequiredProperty() {
      XCTAssertEqual(result["b"], .isNil)
    }
  }
  
  func testInsideRequiredProperty() {
    var a = A()
    a.name = "ss"
    a.address = "aaaa"
    a.b = B()
    
    if let result = a.checkRequiredProperty() {
      XCTAssertEqual(result["b.name"], .isNil)
    }
    a.b?.name = ""
    if let result = a.checkRequiredProperty() {
      XCTAssertEqual(result["b.name"], .isEmpty)
    }
    a.b?.name = "aaa"
    if let result = a.checkRequiredProperty() {
      XCTAssertEqual(result, nil)
    }
  }
  
  func testArray() {
    var c = C()
    
    if let result = c.checkRequiredProperty() {
      XCTAssertEqual(result["aList"], .isEmpty)
      XCTAssertEqual(result["bList"], .isEmpty)
      XCTAssertEqual(result["aListOp"], .isNil)
      XCTAssertEqual(result["bListOp"], .isNil)
    }
    
    c.aList = [A()]
    if let result = c.checkRequiredProperty() {
      XCTAssertEqual(result["aList.0.name"], .isNil)
      XCTAssertEqual(result["aList.0.address"], .isEmpty)
      XCTAssertEqual(result["aList.0.b"], .isNil)
    }
    
    c.aList[0].name = "ss"
    c.aList[0].address = "aaaa"
    
    if let result = c.checkRequiredProperty() {
      XCTAssertEqual(result["aList.0.name"], nil)
      XCTAssertEqual(result["aList.0.address"], nil)
      XCTAssertEqual(result["aList.0.b"], .isNil)
    }
    
    c.aList[0].b = B()
    if let result = c.checkRequiredProperty() {
      XCTAssertEqual(result["aList.0.b.name"], .isNil)
    }
  }
}
