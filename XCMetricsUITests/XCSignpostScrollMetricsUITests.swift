//
//  XCSignpostScrollMetricsUITests.swift
//  XCMetricsUITests
//
//  Created by Soaurabh Kakkar on 20/08/20.
//
// NOTE: https://stackoverflow.com/questions/59645536/available-attribute-does-not-work-with-xctest-classes-or-methods

import XCTest

@available(iOS 14.0, *)
final class XCSignpostScrollMetricsUITests: XCTestCase {

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
        
        measure(metrics: [signpostMetric, XCTOSSignpostMetric.scrollDecelerationMetric]) {
            emojiTableView.swipeUp(velocity: .fast)
            stopMeasuring()
            emojiTableView.swipeDown(velocity: .fast)
        }
    }
    
    func testScrollDraggingPerformance() {
        let app = XCUIApplication()
        app.launch()
        
        app.staticTexts["Scroll Performance"].tap()
        let emojiTableView = app.tables.firstMatch
        
        let signpostMetric = self.signpostMetric(for: SignpostName.scrollDraggingSignpost)
        
        measure(metrics: [signpostMetric, XCTOSSignpostMetric.scrollDraggingMetric]) {
            emojiTableView.swipeUp(velocity: .fast)
            stopMeasuring()
            emojiTableView.swipeDown(velocity: .fast)
        }
    }
    
    override class var defaultMeasureOptions: XCTMeasureOptions {
        let measureOptions = XCTMeasureOptions()
        measureOptions.invocationOptions = [.manuallyStop]
        return measureOptions
    }
    
    private func signpostMetric(for name: StaticString) -> XCTOSSignpostMetric {
        return XCTOSSignpostMetric(subsystem: scrollLog.subsystem, category: scrollLog.category, name: String(name))
    }
}
