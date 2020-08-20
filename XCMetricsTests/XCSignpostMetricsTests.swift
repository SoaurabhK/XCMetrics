//
//  XCSignpostMetricsTests.swift
//  XCMetricsTests
//
//  Created by Soaurabh Kakkar on 20/08/20.
//

import XCTest
@testable import XCMetrics

///Permuation Defination: The number of ways to choose a sample of r elements from a set of n distinct objects where order does matter and replacements are not allowed.  When n = r this reduces to n!, a simple factorial of n.
/// nPr = fact(n) / fact(n - r)
final class XCSignpostMetricsTests: XCTestCase {
    let source: [Int] = [1, 2, 3, 4, 5, 6, 7] // 7! = 5040 unique arrays.
    
    // Self.defaultMeasureOptions will be used
    func testPerformanceFunctional() {
        let signpostMetric = self.signpostMetric(for: SignpostName.permutationsOverMutationsFunctionalOptimized4)
        
        self.measure(metrics: [signpostMetric, XCTClockMetric()]) {
            _ = source.permutationsOverMutationsFunctionalOptimized4()
        }
    }
    
    // Self.defaultMeasureOptions will be used
    func testPerformanceNonFunctional() {
        let signpostMetric = self.signpostMetric(for: SignpostName.permutationsOverMutations)
        
        self.measure(metrics: [signpostMetric, XCTClockMetric()]) {
            _ = source.permutationsOverMutations()
        }
    }
    
    // Self.defaultMeasureOptions will be used
    func testPerformanceConcurrent() {
        let signpostMetric = self.signpostMetric(for: SignpostName.permutationsConcurrent)
        
        self.measure(metrics: [signpostMetric, XCTClockMetric()]) {
            _ = source.permutationsConcurrent(concurrentThreads: 4)
        }
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
    
    private func signpostMetric(for name: StaticString) -> XCTOSSignpostMetric {
        return XCTOSSignpostMetric(subsystem: permutationLog.subsystem, category: permutationLog.category, name: String(name))
    }
}

