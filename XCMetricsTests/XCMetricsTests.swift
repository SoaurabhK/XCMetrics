//
//  XCMetricsTests.swift
//  XCMetricsTests
//
//  Created by Soaurabh Kakkar on 20/08/20.
//

import XCTest
@testable import XCMetrics

///Permuation Defination: The number of ways to choose a sample of r elements from a set of n distinct objects where order does matter and replacements are not allowed.  When n = r this reduces to n!, a simple factorial of n.
/// nPr = fact(n) / fact(n - r)
final class XCMetricsTests: XCTestCase {
    let source: [Int] = [1, 2, 3, 4, 5, 6, 7] // 7! = 5040 unique arrays.
    
    // Self.defaultMeasureOptions will be used
    func testPerformanceFunctional() {
        self.measure(metrics: Self.defaultMetrics) {
            _ = source.permutationsOverMutationsFunctionalOptimized4()
        }
    }
    
    // Self.defaultMetrics will be measured
    func testPerformanceNonFunctional() {
        self.measure(options: Self.defaultMeasureOptions) {
            _ = source.permutationsOverMutations()
        }
    }
    
    func testPerformanceConcurrent() {
        let measureOptions = XCTMeasureOptions()
        if #available(iOS 14, *) {
            measureOptions.invocationOptions = [.manuallyStart, .manuallyStop]
        } else {
            // NOTE: .manuallyStop doesn't work on iOS 13 with some metrics
            measureOptions.invocationOptions = [.manuallyStart]
        }
        measureOptions.iterationCount = 10
        
        self.measure(metrics: Self.defaultMetrics, options: measureOptions) {
            startMeasuring()
            _ = source.permutationsConcurrent(concurrentThreads: 4)
            if #available(iOS 14, *) {
                stopMeasuring()
            }
        }
    }
    
    // By default, it returns [XCTClockMetric()]
    // XCTClockMetric() is to measure the number of seconds the block of code takes to execute.
    override class var defaultMetrics: [XCTMetric] {
        return [
            XCTClockMetric(),
            XCTStorageMetric(),
            XCTMemoryMetric(),
            XCTCPUMetric(),
            MonotonicClockMetric()
        ]
    }
    
    // XCTMeasureOptions `default` option, automatically starts/stops measuring and has iterationCount of 5.
    // We have overriden defaultMeasureOptions to have iterationCount of 10. Note that the block is actually invoked `iterationCount` + 1 times, and the first iteration is discarded. This is done to reduce the chance that the first iteration will be an outlier.
    override class var defaultMeasureOptions: XCTMeasureOptions {
        let measureOptions = XCTMeasureOptions()
        measureOptions.iterationCount = 10
        // automatic start/stop measuring with rawValue zero.
        measureOptions.invocationOptions = [XCTMeasureOptions.InvocationOptions(rawValue: 0)]
        return measureOptions
    }
}

