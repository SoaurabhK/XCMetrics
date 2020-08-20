//
//  ImageLocalStorage.swift
//  XCMetrics
//
//  Created by Soaurabh Kakkar on 20/08/20.
//

import UIKit

final class ImageLocalStorage {
    private let folderURL: URL
    
    init(identifier: String) throws {
        let url = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        folderURL = url.appendingPathComponent(identifier)
        try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
    }
    
    func remove(_ filename: String) {
        let url = folderURL.appendingPathComponent(filename)
        try? FileManager.default.removeItem(at: url)
    }
    
    func store(_ image: UIImage, filename: String) {
        let url = folderURL.appendingPathComponent(filename)
        let data = image.jpegData(compressionQuality: 1)
        try? data?.write(to: url, options: .atomicWrite)
    }
    
    func load(withFilename filename: String) -> UIImage? {
        let url = folderURL.appendingPathComponent(filename)
        return UIImage(contentsOfFile: url.path)
    }
}

