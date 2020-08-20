//
//  ImageProcessor.swift
//  XCMetrics
//
//  Created by Soaurabh Kakkar on 20/08/20.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import UIKit

final class ImageProcessor {
    class func processImage(_ inputImage: UIImage) -> UIImage {
        let context = CIContext(options: nil)
        let filter = CIFilter.sepiaTone()
        filter.inputImage = CIImage(image: inputImage)
        filter.intensity = 0.7
        guard let ciOutputImage = filter.outputImage else { return inputImage }
        guard let cgOutputImage = context.createCGImage(ciOutputImage, from: ciOutputImage.extent) else { return inputImage }
        return UIImage(cgImage: cgOutputImage)
    }
}
