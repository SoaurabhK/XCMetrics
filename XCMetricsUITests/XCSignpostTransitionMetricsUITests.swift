//
//  XCSignpostTransitionMetricsUITests.swift
//  XCMetricsUITests
//
//  Created by Soaurabh Kakkar on 20/08/20.
//

import XCTest

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
        
        let metrics: [XCTMetric]
        if #available(iOS 14, *) {
            metrics = [signpostMetric, OSSignpostMetric.navigationTransitionMetric]
        } else {
            metrics = [signpostMetric]
        }
        
        measure(metrics: metrics) {
            let backButton = app.navigationBars.buttons["Back"]
            if backButton.exists { backButton.tap() }
            startMeasuring()
            scrollPerfCell.tap()
        }
    }
    
    override class var defaultMeasureOptions: XCTMeasureOptions {
        let measureOptions = XCTMeasureOptions()
        measureOptions.invocationOptions = [.manuallyStart]
        return measureOptions
    }
    
    private func signpostMetric(for name: StaticString) -> OSSignpostMetric {
        return OSSignpostMetric(subsystem: navTransitionLog.subsystem, category: navTransitionLog.category, name: String(name))
    }
}
