//
//  InstrumentHook.swift
//  XCMetrics
//
//  Created by Soaurabh Kakkar on 29/08/20.
//

import Foundation
import InterposeKit

final class MXMInstrumentHook: NSObject {
    static var serialInstrumentalsQueue: Interpose? {
        try? Interpose(NSClassFromString("MXMInstrument")!) {
            try $0.prepareHook(
                Selector(("initWithInstrumentals:")),
                methodSignature: (@convention(c) (NSObject, Selector, AnyObject) -> NSObject).self,
                hookSignature: (@convention(block) (NSObject, AnyObject) -> NSObject).self) {
                store in { `self`, inputInstrumentals  in
                    let hookedInstrument = store.original(`self`, store.selector, inputInstrumentals)
                    hookedInstrument.setValue(DispatchQueue(label: "com.apple.metricmeasurement.instrument.instrumentals.hooked"), forKey: "_instrumentalsQueue")
                    return hookedInstrument
                }
            }
        }
    }
}
