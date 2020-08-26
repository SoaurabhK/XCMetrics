//
//  XCAppLaunchMetricsUITests.swift
//  XCMetricsUITests
//
//  Created by Soaurabh Kakkar on 20/08/20.
//

import XCTest
import InterposeKit

final class XCAppLaunchMetricsUITests: XCAppLaunchHookedTestCase {

    override func setUpWithError() throws {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }
    
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        let app = XCUIApplication()
        
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            app.launch()
        }
    }
    
    // waitUntilResponsive specifies the end of the application launch interval to be when the application has displayed the first frame and is responsive.
    // NOTE: https://stackoverflow.com/questions/59645536/available-attribute-does-not-work-with-xctest-classes-or-methods
    func testLaunchPerfUntilResponsive() throws {
        // This measures how long it takes to launch your application.
        guard #available(iOS 14, *) else { return }
        let app = XCUIApplication()
        
        measure(metrics: [XCTApplicationLaunchMetric(waitUntilResponsive: true)]) {
            app.launch()
            app.activate()
        }
    }
}
