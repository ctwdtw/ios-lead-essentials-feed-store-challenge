//
//  XCTestCase+MemoryLeakTracking.swift
//  Tests
//
//  Created by Paul Lee on 2020/10/3.
//  Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation
import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
