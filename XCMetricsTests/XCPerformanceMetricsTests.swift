//
//  XCPerformanceMetricsTests.swift
//  XCMetricsTests
//
//  Created by Soaurabh Kakkar on 20/08/20.
//

import XCTest
@testable import XCMetrics

///Permuation Defination: The number of ways to choose a sample of r elements from a set of n distinct objects where order does matter and replacements are not allowed.  When n = r this reduces to n!, a simple factorial of n.
/// nPr = fact(n) / fact(n - r)
final class XCPerformanceMetricsTests: XCTestCase {
    let source: [Int] = [1, 2, 3, 4, 5, 6, 7] // 7! = 5040 unique arrays.
    
    // Self.defaultPerformanceMetrics will be measured
    func testPerformanceFunctional() {
        self.measure {
            _ = source.permutationsOverMutationsFunctionalOptimized4()
        }
    }
    
    func testPerformanceNonFunctional() {
        self.measureMetrics(Self.defaultPerformanceMetrics, automaticallyStartMeasuring: true) {
            _ = source.permutationsOverMutations()
        }
    }
    
    func testPerformanceConcurrent() {
        self.measureMetrics(Self.defaultPerformanceMetrics, automaticallyStartMeasuring: false) {
            startMeasuring()
            _ = source.permutationsConcurrent(concurrentThreads: 4)
            stopMeasuring()
        }
    }
    
    // By default, it returns [XCTPerformanceMetric.wallClockTime]
    // XCTPerformanceMetric.wallClockTime is to measure the number of seconds the block of code takes to execute.
    override class var defaultPerformanceMetrics: [XCTPerformanceMetric] {
        return XCTPerformanceMetric.all
    }
}

