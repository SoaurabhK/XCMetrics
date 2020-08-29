//
//  MXMInstrumentHookedTestCase.swift
//  XCMetrics
//
//  Created by Soaurabh Kakkar on 29/08/20.
//

import XCTest
import InterposeKit

class MXMInstrumentHookedTestCase: XCTestCase {
    private static var serialInstrumentalsQueue: Interpose?
    
    class override func setUp() {
        super.setUp()
        serialInstrumentalsQueue = MXMInstrumentHook.serialInstrumentalsQueue
    }
    
    class override func tearDown() {
        _ = try? serialInstrumentalsQueue?.revert()
        super.tearDown()
    }
}
