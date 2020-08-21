//
//  XCAsyncPerformanceTests.swift
//  XCMetricsTests
//
//  Created by Soaurabh Kakkar on 20/08/20.
//

import XCTest
@testable import XCMetrics

final class XCAsyncPerformanceTests: XCTestCase {
    
    func testPerformanceAsyncTask() {
        let signpostMetric = self.signpostMetric(for: SignpostName.asyncTask)
        
        self.measure(metrics: [signpostMetric, XCTClockMetric()], options: Self.defaultMeasureOptions) {
            let exp = expectation(description: "asyncTask")
            self.startMeasuring()
            asyncTask(withDuration: 0.1) {
                if #available(iOS 14, *) {
                    self.stopMeasuring()
                }
                exp.fulfill()
            }
            wait(for: [exp], timeout: 0.5)
        }
    }
    
    func testPerformanceAsyncTaskWallClock() {
        self.measureMetrics([XCTPerformanceMetric.wallClockTime], automaticallyStartMeasuring: false) {
            let exp = expectation(description: "asyncTask")
            self.startMeasuring()
            asyncTask(withDuration: 0.1) {
                self.stopMeasuring()
                exp.fulfill()
            }
            wait(for: [exp], timeout: 0.2)
        }
    }
    
    // XCTMeasureOptions `default` option, automatically starts/stops measuring and has iterationCount of 5.
    // We have overriden defaultMeasureOptions to have iterationCount of 10. Note that the block is actually invoked `iterationCount` + 1 times, and the first iteration is discarded. This is done to reduce the chance that the first iteration will be an outlier.
    override class var defaultMeasureOptions: XCTMeasureOptions {
        let measureOptions = XCTMeasureOptions()
        measureOptions.iterationCount = 10
        if #available(iOS 14, *) {
            measureOptions.invocationOptions = [.manuallyStart, .manuallyStop]
        } else {
            // NOTE: .manuallyStop doesn't work on iOS 13 with some metrics
            measureOptions.invocationOptions = [.manuallyStart]
        }
        return measureOptions
    }
    
    private func signpostMetric(for name: StaticString) -> OSSignpostMetric {
        return OSSignpostMetric(subsystem: asyncTaskLog.subsystem, category: asyncTaskLog.category, name: String(name))
    }
}
