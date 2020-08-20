//
//  ImageProcessingViewController.swift
//  XCMetrics
//
//  Created by Soaurabh Kakkar on 20/08/20.
//

import UIKit
import os.signpost

private let processImageOSLog = OSLog(subsystem: processImageLog.subsystem, category: processImageLog.category)

final class ImageProcessingViewController: UIViewController {
    private let originalImage = UIImage(named: "cat")!
    private let imageStorage: ImageLocalStorage? = {
        return try? ImageLocalStorage(identifier: "Background")
    }()
    
    @IBOutlet weak var originalImageView: UIImageView!
    @IBOutlet weak var processedImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originalImageView.image = originalImage
    }
    
    @IBAction func processImage(_ sender: UIButton) {
        os_signpost(.begin, log: processImageOSLog, name: SignpostName.processImage)
        
        imageStorage?.store(originalImage, filename: "original")
        
        let processedImage = ImageProcessor.processImage(originalImage)
        imageStorage?.store(processedImage, filename: "processed")
        processedImageView.image = processedImage
        
        os_signpost(.end, log: processImageOSLog, name: SignpostName.processImage)
    }
}

