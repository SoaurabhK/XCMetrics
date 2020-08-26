//
//  XCSignpostHookTestCase.swift
//  XCMetrics
//
//  Created by Soaurabh Kakkar on 25/08/20.
//

import XCTest
import InterposeKit

class XCSignpostHookedTestCase: XCTestCase {
    private static var signpostHook: Interpose?
    class override func setUp() {
        super.setUp()
        signpostHook = XCTOSSignpostMetric.signpostHook
    }
    
    class override func tearDown() {
        _ = try? signpostHook?.revert()
        Measurements.clear()
        super.tearDown()
    }
}
