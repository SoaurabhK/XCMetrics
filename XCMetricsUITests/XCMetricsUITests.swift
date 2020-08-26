//
//  XCMetricsUITests.swift
//  XCMetricsUITests
//
//  Created by Soaurabh Kakkar on 20/08/20.
//

import XCTest

final class XCMetricsUITests: XCSignpostHookedTestCase {
    
    typealias MetricAlloc = @convention(c) (XCTMetric.Type, Selector) -> NSObject
    typealias MetricInitWithProcessName = @convention(c) (NSObject, Selector, String) -> XCTMetric
    
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
        // NOTE: XCTCPUMetric(application: app) and XCTMemoryMetric(application: app) won’t work on iOS 14. However, It will work when checked on iOS 13.6, I still doubt their accuracy, so we should discard any outlier cpu/memory values.
        let memoryMetric: XCTMetric
        let cpuMetric: XCTMetric
        if #available(iOS 14, *) {
            memoryMetric = self.initWithProcessName(for: XCTMemoryMetric.self, processName: "XCMetrics")
            cpuMetric = self.initWithProcessName(for: XCTCPUMetric.self, processName: "XCMetrics")
        } else {
            memoryMetric = XCTMemoryMetric(application: app)
            cpuMetric = XCTCPUMetric(application: app)
        }
        
        measure(metrics: [memoryMetric, cpuMetric, signpostMetric, XCTStorageMetric(application: app)], options: measureOptions) {
            processButton.tap()
        }
    }
    
    //initWithProcessName: is a private API, used to ensure support for iOS 14.
    private func initWithProcessName(for type: XCTMetric.Type, processName: String) -> XCTMetric {
        guard type is XCTMemoryMetric.Type ||
              type is XCTCPUMetric.Type ||
              type is XCTStorageMetric.Type else {
            fatalError("CPU, Storage and Memory metric implements initWithProcessName:")
        }
        let allocSelector = NSSelectorFromString("alloc")
        let allocIMP = method_getImplementation(class_getClassMethod(type.self, allocSelector)!)
        let allocMethod = unsafeBitCast(allocIMP, to: MetricAlloc.self)
        let result = allocMethod(type.self, allocSelector)
        
        let initSelector = NSSelectorFromString("initWithProcessName:")
        let methodIMP = result.method(for: initSelector)
        let initMethod = unsafeBitCast(methodIMP, to: MetricInitWithProcessName.self)
        return initMethod(result, initSelector, processName)
    }
    
    private func signpostMetric(for name: StaticString) -> XCTOSSignpostMetric {
        return XCTOSSignpostMetric(subsystem: processImageLog.subsystem, category: processImageLog.category, name: String(name))
    }
}

