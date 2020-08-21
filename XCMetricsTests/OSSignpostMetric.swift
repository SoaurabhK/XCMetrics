//
//  OSSignpostMetric.swift
//  XCMetricsTests
//
//  Created by Soaurabh Kakkar on 21/08/20.
//

import XCTest

final class OSSignpostMetric: XCTOSSignpostMetric {
    override func reportMeasurements(from startTime: XCTPerformanceMeasurementTimestamp, to endTime: XCTPerformanceMeasurementTimestamp) throws -> [XCTPerformanceMeasurement] {
        let measurements = try super.reportMeasurements(from: startTime, to: endTime)
        if #available(iOS 14, *) {
            return measurements
        } else {
            guard let lastMeasurement = measurements.last else { return [] }
            return [lastMeasurement]
        }
    }
}
