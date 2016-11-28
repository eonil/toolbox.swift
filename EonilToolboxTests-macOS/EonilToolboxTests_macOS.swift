//
//  EonilToolboxTests_macOS.swift
//  EonilToolboxTests-macOS
//
//  Created by Hoon H. on 2016/06/19.
//  Copyright © 2016 Eonil. All rights reserved.
//

import XCTest
@testable import EonilToolbox

class EonilToolboxTests_macOS: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock {
//            // Put the code you want to measure the time of here.
//        }
//    }

    func testSplitInY1() {
        let box = CGRect(x: 0, y: -10, width: 100, height: 100).toBox().toSilentBox()
        do {
            let (a, b, c) = box.splitInY(0, 0, 100%)
            XCTAssert(a.size.x == 100)
            XCTAssert(a.size.y == 0)
            XCTAssert(b.size.x == 100)
            XCTAssert(b.size.y == 0)
            XCTAssert(c.size.x == 100)
            XCTAssert(c.size.y == 100)
        }
    }
}
