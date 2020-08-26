//
//  Measurements.swift
//  XCMetrics
//
//  Created by Soaurabh Kakkar on 25/08/20.
//

import XCTest

struct Measurements {
    private static var storage = [Signpost: [XCTPerformanceMeasurement]]()
    static func value(for signpost: Signpost) -> [XCTPerformanceMeasurement] {
        return storage[signpost] ?? []
    }
    
    static func update(measurements: [XCTPerformanceMeasurement], for signpost: Signpost) {
        storage[signpost] = measurements
    }
    
    static func clear() {
        storage.removeAll()
    }
}
