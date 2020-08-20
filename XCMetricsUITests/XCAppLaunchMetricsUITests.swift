//
//  XCAppLaunchMetricsUITests.swift
//  XCMetricsUITests
//
//  Created by Soaurabh Kakkar on 20/08/20.
//
// NOTE: https://stackoverflow.com/questions/59645536/available-attribute-does-not-work-with-xctest-classes-or-methods

import XCTest

final class XCAppLaunchMetricsUITests: XCTestCase {

    override func setUpWithError() throws {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }
    
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
    
    // waitUntilResponsive specifies the end of the application launch interval to be when the application has displayed the first frame and is responsive.
    @available(iOS 14.0, *)
    func testLaunchPerfUntilResponsive() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric(waitUntilResponsive: true)]) {
            XCUIApplication().launch()
        }
    }
}
