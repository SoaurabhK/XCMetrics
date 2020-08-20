//
//  XCSignpostTransitionMetricsUITests.swift
//  XCMetricsUITests
//
//  Created by Soaurabh Kakkar on 20/08/20.
//
// NOTE: https://stackoverflow.com/questions/59645536/available-attribute-does-not-work-with-xctest-classes-or-methods

import XCTest

@available(iOS 14.0, *)
final class XCSignpostTransitionMetricsUITests: XCTestCase {
    
    override func setUpWithError() throws {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }

    func testNavigationTransitionPerformance() {
        let app = XCUIApplication()
        app.launch()
        let scrollPerfCell = app.staticTexts["Scroll Performance"]
        
        let signpostMetric = self.signpostMetric(for: SignpostName.scrollViewNavTransition)
        
        measure(metrics: [signpostMetric, XCTOSSignpostMetric.navigationTransitionMetric]) {
            scrollPerfCell.tap()
            stopMeasuring()
            app.navigationBars.buttons["Back"].tap()
        }
    }
    
    override class var defaultMeasureOptions: XCTMeasureOptions {
        let measureOptions = XCTMeasureOptions()
        measureOptions.invocationOptions = [.manuallyStop]
        return measureOptions
    }
    
    private func signpostMetric(for name: StaticString) -> XCTOSSignpostMetric {
        return XCTOSSignpostMetric(subsystem: navTransitionLog.subsystem, category: navTransitionLog.category, name: String(name))
    }
}
