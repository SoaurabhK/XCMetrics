//
//  XCTPerformanceMetric+All.swift
//  XCMetricsTests
//
//  Created by Soaurabh Kakkar on 20/08/20.
//

// wallClockTime: is the time that a clock on the wall (or a stopwatch in hand) would measure as having elapsed between the start of the process and 'now'.

// User CPU Time(userTime): Amount of time the processor worked on the specific program or the amount of time spent in user code.

// System CPU Time(systemTime): Amount of time the processor worked on operating system's functions connected to that specific program or the amount of time spent in kernel code(servicing system calls).

// runTime: Sum of userTime & systemTime

// Note: wall-clock time is not the number of seconds that the process has spent on the CPU. it is the elapsed time, including time spent waiting for its turn on the CPU (while other processes get to run).

// SideNote:
// 1. On a single core machine wall-clock time will always be greater than the cpu-time.
// 2. iOS 14 always reports systemTime as zero irrespective of system/kernal calls.

// VM Allocations: System reserves a VM memory for every app/process and as a developer you can influence this memory usage by creating less images, reducing the number of malloc calls etc.
// For instance, when you allocate a large CGImage, a tiny object is allocated on the heap, but the many megabytes of image data is allocated in a separate VM region. In an image-heavy application, your heap may be relatively small but your VM regions may be rather large. In that case, you'd need to take a closer look at the size and number of images your application has loaded at any given moment.

// Heap Allocations: Consist of the memory allocations your application makes i.e. all your Swift and Objective-C objects.

// Persistent Memory: objects that currently exist in memory.
// Transient/Temporary Memory: Objects that have existed but have since been deallocated.
// Persistent objects are using up memory, transient objects have had their memory released.

import XCTest

public extension XCTPerformanceMetric {
    static let userTime = XCTPerformanceMetric(rawValue: "com.apple.XCTPerformanceMetric_UserTime")
    static let runTime = XCTPerformanceMetric(rawValue: "com.apple.XCTPerformanceMetric_RunTime")
    static let systemTime = XCTPerformanceMetric(rawValue: "com.apple.XCTPerformanceMetric_SystemTime")
    static let transientVMKB = XCTPerformanceMetric(rawValue: "com.apple.XCTPerformanceMetric_TransientVMAllocationsKilobytes")
    static let temporaryHeapKB = XCTPerformanceMetric(rawValue: "com.apple.XCTPerformanceMetric_TemporaryHeapAllocationsKilobytes")
    static let highWatermarkVM = XCTPerformanceMetric(rawValue: "com.apple.XCTPerformanceMetric_HighWaterMarkForVMAllocations")
    static let totalHeapKB = XCTPerformanceMetric(rawValue: "com.apple.XCTPerformanceMetric_TotalHeapAllocationsKilobytes")
    static let persistentVM = XCTPerformanceMetric(rawValue: "com.apple.XCTPerformanceMetric_PersistentVMAllocations")
    static let persistentHeap = XCTPerformanceMetric(rawValue: "com.apple.XCTPerformanceMetric_PersistentHeapAllocations")
    static let transientHeapKB = XCTPerformanceMetric(rawValue: "com.apple.XCTPerformanceMetric_TransientHeapAllocationsKilobytes")
    static let persistentHeapNodes = XCTPerformanceMetric(rawValue: "com.apple.XCTPerformanceMetric_PersistentHeapAllocationsNodes")
    static let highWatermarkHeap = XCTPerformanceMetric(rawValue: "com.apple.XCTPerformanceMetric_HighWaterMarkForHeapAllocations")
    static let transientHeapNodes = XCTPerformanceMetric(rawValue: "com.apple.XCTPerformanceMetric_TransientHeapAllocationsNodes")
    
    static let all: [XCTPerformanceMetric] = [.wallClockTime,
                                                     .userTime,
                                                     .runTime,
                                                     .systemTime,
                                                     .transientVMKB,
                                                     .temporaryHeapKB,
                                                     .highWatermarkVM,
                                                     .totalHeapKB,
                                                     .persistentVM,
                                                     .persistentHeap,
                                                     .transientHeapKB,
                                                     .persistentHeapNodes,
                                                     .highWatermarkHeap,
                                                     .transientHeapNodes]
}

