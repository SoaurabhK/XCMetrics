//
//  MonotonicClockMetric.swift
//  XCMetricsTests
//
//  Created by Soaurabh Kakkar on 20/08/20.
//

import XCTest

final class MonotonicClockMetric: NSObject, XCTMetric {
    var startTimes = AtomicArray<UInt64>()
    var endTimes = AtomicArray<UInt64>()
    
    // This will get called on main queue/thread.
    func reportMeasurements(from startTime: XCTPerformanceMeasurementTimestamp, to endTime: XCTPerformanceMeasurementTimestamp) throws -> [XCTPerformanceMeasurement] {
        
        let startTimeNano = startTime.absoluteTimeNanoSeconds
        let endTimeNano = endTime.absoluteTimeNanoSeconds
        
        // NOTE: We can change the order of if and else-if to run our monotonic-time implementation.
        let timeDiffNS: UInt64
        if endTimeNano > startTimeNano {
            timeDiffNS = endTimeNano - startTimeNano
        } else if let startTimeNS = startTimes.first, let endTimeNS = endTimes.first, endTimeNS > startTimeNS {
            timeDiffNS = endTimeNS - startTimeNS
            startTimes.removeFirst()
            endTimes.removeFirst()
        } else {
            timeDiffNS = .min // or throw exception here.
        }
        
        let measurement = Measurement(value: Double(timeDiffNS), unit: Unit(symbol: "ns"))
        return [XCTPerformanceMeasurement(identifier: "com.sk.XCTPerformanceMetric_MonotonicClockTime", displayName: "Monotonic Clock Time", value: measurement)]
    }
    
    // This will get called on background queue i.e. any random thread for each iteration.
    func willBeginMeasuring() {
        startTimes.append(DispatchTime.now().uptimeNanoseconds)
    }

    // This will get called on background queue i.e. any random thread for each iteration.
    func didStopMeasuring() {
        endTimes.append(DispatchTime.now().uptimeNanoseconds)
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}

