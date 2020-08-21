//
//  XCMetricsUITests.swift
//  XCMetricsUITests
//
//  Created by Soaurabh Kakkar on 20/08/20.
//

import XCTest

final class XCMetricsUITests: XCTestCase {
    
    override func setUpWithError() throws {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }
    
    func testImageProcessingPerformance() {
        let app = XCUIApplication()
        
        app.launch()
        app.staticTexts["Image Processing"].tap()
        let processButton = app.buttons["Process"]
        
        let measureOptions = XCTMeasureOptions()
        measureOptions.iterationCount = 10
        
        let signpostMetric = self.signpostMetric(for: SignpostName.processImage)
        
        // NOTE: XCTClockMetric doesn't make much sense in UITest(s) because it will target the time of execution in current process, not the process targetted by XCUIApplication proxy.
        // NOTE: XCTCPUMetric(application: app) and XCTMemoryMetric(application: app) won’t work on iOS 14. However, It will work when checked on iOS 13.6, I still doubt their accuracy, so we should avoid it.
        measure(metrics: [signpostMetric, XCTCPUMetric(application: app), XCTStorageMetric(application: app), XCTMemoryMetric(application: app)], options: measureOptions) {
            processButton.tap()
        }
    }
    
    private func signpostMetric(for name: StaticString) -> OSSignpostMetric {
        return OSSignpostMetric(subsystem: processImageLog.subsystem, category: processImageLog.category, name: String(name))
    }
}

