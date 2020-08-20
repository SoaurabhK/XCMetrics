//
//  Log.swift
//  XCMetrics
//
//  Created by Soaurabh Kakkar on 20/08/20.
//

import Foundation

struct Log {
    let subsystem: String
    let category: String
}

let permutationLog = Log(subsystem: "com.sk.XCMetrics", category: "PermutationOperations")
let asyncTaskLog = Log(subsystem: "com.sk.XCMetrics", category: "asyncTasks")
let processImageLog = Log(subsystem: "com.sk.XCMetrics", category: "processImages")
let scrollLog = Log(subsystem: "com.sk.XCMetrics", category: "scrollOperations")
let navTransitionLog = Log(subsystem: "com.sk.XCMetrics", category: "navigationTransitions")

