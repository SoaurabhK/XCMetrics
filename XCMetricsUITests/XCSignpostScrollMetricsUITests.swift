//
//  XCSignpostScrollMetricsUITests.swift
//  XCMetricsUITests
//
//  Created by Soaurabh Kakkar on 20/08/20.
//

import XCTest

final class XCSignpostScrollMetricsUITests: XCSignpostHookedTestCase {

    override func setUpWithError() throws {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }
    
    func testScrollDecelerationPerformance() {
        let app = XCUIApplication()
        app.launch()
        
        app.staticTexts["Scroll Performance"].tap()
        let emojiTableView = app.tables.firstMatch
        
        let signpostMetric = self.signpostMetric(for: SignpostName.scrollDecelerationSignpost)
        
        let metrics: [XCTMetric]
        if #available(iOS 14, *) {
            metrics = [signpostMetric, XCTOSSignpostMetric.scrollDecelerationMetric]
        } else {
            metrics = [signpostMetric]
        }
        
        measure(metrics: metrics) {
            emojiTableView.swipeDown(velocity: .fast)
            startMeasuring()
            emojiTableView.swipeUp(velocity: .fast)
        }
    }
    
    func testScrollDraggingPerformance() {
        let app = XCUIApplication()
        app.launch()
        
        app.staticTexts["Scroll Performance"].tap()
        let emojiTableView = app.tables.firstMatch
        
        let signpostMetric = self.signpostMetric(for: SignpostName.scrollDraggingSignpost)
        
        let metrics: [XCTMetric]
        if #available(iOS 14, *) {
            metrics = [signpostMetric, XCTOSSignpostMetric.scrollDraggingMetric]
        } else {
            metrics = [signpostMetric]
        }
        
        measure(metrics: metrics) {
            emojiTableView.swipeDown(velocity: .fast)
            startMeasuring()
            emojiTableView.swipeUp(velocity: .fast)
        }
    }
    
    override class var defaultMeasureOptions: XCTMeasureOptions {
        let measureOptions = XCTMeasureOptions()
        measureOptions.invocationOptions = [.manuallyStart]
        return measureOptions
    }
    
    private func signpostMetric(for name: StaticString) -> XCTOSSignpostMetric {
        return XCTOSSignpostMetric(subsystem: scrollLog.subsystem, category: scrollLog.category, name: String(name))
    }
}
