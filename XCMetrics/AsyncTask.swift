//
//  AsyncTask.swift
//  XCMetrics
//
//  Created by Soaurabh Kakkar on 20/08/20.
//

import Foundation
import os.signpost

private let asyncTaskOSLog = OSLog(subsystem: asyncTaskLog.subsystem, category: asyncTaskLog.category)
private let signpostID = OSSignpostID(log: asyncTaskOSLog)

func asyncTask(withDuration duration: Double, _ completion: @escaping () -> Void) {
    os_signpost(.begin, log: asyncTaskOSLog, name: SignpostName.asyncTask, signpostID: signpostID, "task started: %{public}.2f duration", duration)
    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
        os_signpost(.end, log: asyncTaskOSLog, name: SignpostName.asyncTask, signpostID: signpostID, "task ended: %{public}.2f duration", duration)
        completion()
    }
}

