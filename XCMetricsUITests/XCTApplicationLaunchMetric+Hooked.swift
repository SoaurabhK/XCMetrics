//
//  XCTApplicationLaunchMetric+Hooked.swift
//  XCMetricsUITests
//
//  Created by Soaurabh Kakkar on 25/08/20.
//

import XCTest
import InterposeKit

extension XCTApplicationLaunchMetric {
    static var appLaunchHook: Interpose? {
        try? Interpose(XCTApplicationLaunchMetric.self) {
            try $0.prepareHook(
                #selector(XCTApplicationLaunchMetric.reportMeasurements(from:to:)),
                methodSignature: (@convention(c) (XCTApplicationLaunchMetric, Selector, XCTPerformanceMeasurementTimestamp, XCTPerformanceMeasurementTimestamp) -> [XCTPerformanceMeasurement]).self,
                hookSignature: (@convention(block) (XCTApplicationLaunchMetric, XCTPerformanceMeasurementTimestamp, XCTPerformanceMeasurementTimestamp) -> [XCTPerformanceMeasurement]).self) {
                store in { `self`, startTime, endTime  in
                    let measurements = store.original(`self`, store.selector, startTime, endTime)
                    return hookedValue(for: signpost(from: `self`), with: measurements)
                }
            }
        }
    }
}
