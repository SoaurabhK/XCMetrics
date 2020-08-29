//
//  XCAppLaunchHookedTestCase.swift
//  XCMetricsUITests
//
//  Created by Soaurabh Kakkar on 25/08/20.
//

import XCTest
import InterposeKit

class XCAppLaunchHookedTestCase: MXMInstrumentHookedTestCase {
    private static var appLaunchHook: Interpose?
    
    class override func setUp() {
        super.setUp()
        appLaunchHook = XCTApplicationLaunchMetric.appLaunchHook
    }
    
    class override func tearDown() {
        _ = try? appLaunchHook?.revert()
        Measurements.clear()
        super.tearDown()
    }
}
