//
//  ImagePickerViewModel.swift
//  Acnesight
//
//  Created by Ahmed Nizhan Haikal on 17/06/25.
//

import Foundation
import UIKit
import CoreML
import Vision

struct BoundingBox: Identifiable {
    let id = UUID()
    let label: String
    let confidence: Float
    let rect: CGRect
}

class ImagePickerViewModel: ObservableObject {
    func processImage(_ image: UIImage, completion: @escaping ([BoundingBox]) -> Void) {
        guard let letterboxed = letterboxImage(image),
              let cgImage = letterboxed.cgImage else {
            completion([])
            return
        }
        
        do {
            let config = MLModelConfiguration()
            let model = try best(configuration: config).model
            let vnModel = try VNCoreMLModel(for: model)
            
            let request = VNCoreMLRequest(model: vnModel) { req, error in
                DispatchQueue.main.async {
                    var boxes: [BoundingBox] = []
                    if let results = req.results as? [VNRecognizedObjectObservation] {
                        print(results)
                        for obj in results {
                            if let topLabel = obj.labels.first {
                                boxes.append(BoundingBox(
                                    label: topLabel.identifier,
                                    confidence: topLabel.confidence,
                                    rect: obj.boundingBox
                                ))
                            }
                        }
                    }
                    completion(boxes)
                }
            }
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            try handler.perform([request])
        } catch {
            print("Model failed: \(error)")
        }
    }
    
    func letterboxImage(_ image: UIImage, targetSize: CGSize = CGSize(width: 640, height: 640)) -> UIImage? {
        let originalSize = image.size
        let scale = min(targetSize.width / originalSize.width, targetSize.height / originalSize.height)

        let resizedSize = CGSize(width: originalSize.width * scale, height: originalSize.height * scale)
        let xOffset = (targetSize.width - resizedSize.width) / 2
        let yOffset = (targetSize.height - resizedSize.height) / 2

        UIGraphicsBeginImageContextWithOptions(targetSize, false, image.scale)

        UIColor.black.setFill()
        UIRectFill(CGRect(origin: .zero, size: targetSize))

        image.draw(in: CGRect(x: xOffset, y: yOffset, width: resizedSize.width, height: resizedSize.height))

        let letterboxedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return letterboxedImage
    }
}
