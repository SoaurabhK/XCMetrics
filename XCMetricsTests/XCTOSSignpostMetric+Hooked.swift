//
//  XCTOSSignpostMetric+Hooks.swift
//  XCMetricsTests
//
//  Created by Soaurabh Kakkar on 21/08/20.
//

import XCTest
import InterposeKit

func signpost(from metric: XCTMetric) -> Signpost {
    guard metric is XCTApplicationLaunchMetric || metric is XCTOSSignpostMetric, let metricObject = metric as? NSObject else {
        fatalError("Expected AppLaunch or Signpost Metric!")
    }
    let underlyingMetricSelector = NSSelectorFromString("_underlyingMetric")
    let underlyingMetricIMP = metricObject.method(for: underlyingMetricSelector)
    let underlyingMetricMethod = unsafeBitCast(underlyingMetricIMP, to: (@convention(c) (NSObject, Selector) -> NSObject).self)
    let signpostUnderlyingMetric = underlyingMetricMethod(metricObject, underlyingMetricSelector)
    
    let subsystemSelector = NSSelectorFromString("subsystem")
    let subsystemIMP = signpostUnderlyingMetric.method(for: subsystemSelector)
    let subsystemMethod = unsafeBitCast(subsystemIMP, to: (@convention(c) (NSObject, Selector) -> String).self)
    let subsystem = subsystemMethod(signpostUnderlyingMetric, subsystemSelector)
    
    let categorySelector = NSSelectorFromString("category")
    let categoryIMP = signpostUnderlyingMetric.method(for: categorySelector)
    let categoryMethod = unsafeBitCast(categoryIMP, to: (@convention(c) (NSObject, Selector) -> String).self)
    let category = categoryMethod(signpostUnderlyingMetric, categorySelector)
    
    let nameSelector = NSSelectorFromString("name")
    let nameIMP = signpostUnderlyingMetric.method(for: nameSelector)
    let nameMethod = unsafeBitCast(nameIMP, to: (@convention(c) (NSObject, Selector) -> String).self)
    let name = nameMethod(signpostUnderlyingMetric, nameSelector)
    
    return Signpost(subsystem: subsystem, category: category, name: name)
}

func hookedValue(for signpost: Signpost, with measurements: [XCTPerformanceMeasurement]) -> [XCTPerformanceMeasurement] {
    if measurements.count >= Measurements.value(for: signpost).count {
        Measurements.update(measurements: measurements, for: signpost)
    }
    if #available(iOS 14, *) {
        return Measurements.value(for: signpost)
    } else {
        guard let lastMeasurement = Measurements.value(for: signpost).last else {
            return []
        }
        return [lastMeasurement]
    }
}

extension XCTOSSignpostMetric {
    static var signpostHook: Interpose? {
        try? Interpose(XCTOSSignpostMetric.self) {
            try $0.prepareHook(
                #selector(XCTOSSignpostMetric.reportMeasurements(from:to:)),
                methodSignature: (@convention(c) (XCTOSSignpostMetric, Selector, XCTPerformanceMeasurementTimestamp, XCTPerformanceMeasurementTimestamp) -> [XCTPerformanceMeasurement]).self,
                hookSignature: (@convention(block) (XCTOSSignpostMetric, XCTPerformanceMeasurementTimestamp, XCTPerformanceMeasurementTimestamp) -> [XCTPerformanceMeasurement]).self) {
                store in { `self`, startTime, endTime  in
                    let measurements = store.original(`self`, store.selector, startTime, endTime)
                    return hookedValue(for: signpost(from: `self`), with: measurements)
                }
            }
        }
    }
}
