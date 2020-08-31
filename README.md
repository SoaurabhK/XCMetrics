XCMetrics: Measure performance metrics using XCTest
======================================

```XCMetrics``` is a reference implementation to accurately measure performance metrics of your code using Unit and UI tests. It provides detailed examples covering both old( i.e. XCTPerformanceMetric) & the new(i.e. XCTMetric) performance-testing system. It also fixes bugs/peculiarities in the XCTest performance APIs with runtime hooks(i.e. Monkey Patching), making it more stable & consistent.

##  Identifying Performance Bottlenecks & Regressions
Performance tests helps in identifying the impact of your code in terms of various metrics like CPU, Clock, Memory, Storage, Signpost, AppLaunch and more. Capturing performance metrics in your CI pipeline helps in identifying performance bottlenecks and regressions produced by your code over-time. If your performance metrics are going off, then Instruments can help in analysing the root cause.

## What's Inside
Detailed examples of performance testing covering the usage of following metrics:<br/>
1.  ```XCTCPUMetric``` to record information about CPU activity during a performance test.
2.  ```XCTClockMetric``` to record the time that elapses during a performance test.
3.  ```XCTMemoryMetric``` to record the physical memory that a performance test uses.
4.  ```XCTOSSignpostMetric``` to record the time that a performance test spends executing a signposted region of code.
5.  ```XCTStorageMetric``` to record the amount of data that a performance test logically writes to storage.
6.  ```XCTApplicationLaunchMetric``` to record the application launch duration for a performance test.
7.  ```MonotonicClockMetric``` to record the time(in nanoseconds) that elapses during a performance test, implemented as a custom ```XCTMetric```.
8.  ```scrollDecelerationMetric``` to record scroll deceleration animations.
9.  ```scrollDraggingMetric``` to record scroll-dragging animations.
10.  ```navigationTransitionMetric``` to record the duration of navigation transitions between views.
11.  ```wallClockTime``` to record the time in seconds to execute a block of code.
12.  And, all private metrics of ```XCTPerformanceMetric``` system.

## Tools & Support
1.  Xcode 12.0 Beta 6, Build version 12A8189n.
2.  Swift 5.3 and later.
3.  iOS 13 and later.

## Dependencies
```XCMetrics``` uses [InterposeKit](https://github.com/steipete/InterposeKit) for adding runtime hooks(i.e. swizzling).

## Contributing
XCMetrics welcomes contributions in the form of GitHub issues and pull-requests: <br/>
1.  For PRs, please add the purpose and summary of your changes in the PR description.<br/>
2.  For issues, please add the steps to reproduce and tools/OS version.<br/>
3.  Make sure you test your contributions.<br/>

By submitting a pull request, you represent that you have the right to license your contribution to Soaurabh Kakkar and the community, and agree by submitting the patch that your contributions are licensed under the XCMetrics project license.

## License
XCMetrics is licensed under the [MIT License](LICENSE.md)

## References
https://developer.apple.com/documentation/os/logging/recording_performance_data<br/>
https://developer.apple.com/documentation/xctest/performance_tests<br/>
https://developer.apple.com/documentation/xctest/xctestcase<br/>
https://indiestack.com/2018/02/xcodes-secret-performance-tests<br/>
https://developer.apple.com/videos/play/wwdc2018/405<br/>
https://developer.apple.com/videos/play/wwdc2019/417<br/>
https://developer.apple.com/videos/play/wwdc2020/10077
