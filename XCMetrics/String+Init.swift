//
//  String+Init.swift
//  XCMetrics
//
//  Created by Soaurabh Kakkar on 20/08/20.
//

import Foundation

extension String {
    init(_ staticString: StaticString) {
        self = staticString.withUTF8Buffer {
            String(decoding: $0, as: UTF8.self)
        }
    }
}

