//
//  ContentView.swift
//  Acnesight
//
//  Created by Ahmed Nizhan Haikal on 11/06/25.
//

import SwiftUI
import Vision
import CoreML
import UIKit

struct ContentView: View {
    @State private var showCamera = false
    @State private var inputImage: UIImage?
    @State private var detectedBoxes: [BoundingBox] = []
    @State private var showResult = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Spacer()
                    
                    if let image = inputImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height:300)
                    } else {
                        Text("Take a photo to start")
                            .font(.title2)
                    }
                    
                    Button(action: {
                        showCamera = true
                    }) {
                        Image(systemName: "camera")
                            .font(.largeTitle)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .sheet(isPresented: $showCamera) {
            ImagePicker(image: $inputImage, onImagePicked: processImage)
        }
        .background(
            NavigationLink(
                destination: ResultPage(image: inputImage, detections: detectedBoxes),
                isActive: $showResult
            ){
                EmptyView()
            }
                .hidden()
        )
    }
    
    func processImage(_ image: UIImage) {
        guard let letterboxed = letterboxImage(image),
              let cgImage = letterboxed.cgImage else { return }
        
        do {
            let config = MLModelConfiguration()
            let model = try best(configuration: config).model
            let vnModel = try VNCoreMLModel(for: model)
            print(model.modelDescription.inputDescriptionsByName)
            
            let request = VNCoreMLRequest(model: vnModel) { req, error in
                DispatchQueue.main.async {
                    detectedBoxes.removeAll()
                    if let results = req.results as? [VNRecognizedObjectObservation] {
                        print(results)
                        for obj in results {
                            if let topLabel = obj.labels.first {
                                detectedBoxes.append(BoundingBox(
                                    label: topLabel.identifier,
                                    confidence: topLabel.confidence,
                                    rect: obj.boundingBox
                                ))
                            }
                        }
                        showResult = true
                    }
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

        // Fill background (black padding)
        UIColor.black.setFill()
        UIRectFill(CGRect(origin: .zero, size: targetSize))

        // Draw resized image centered
        image.draw(in: CGRect(x: xOffset, y: yOffset, width: resizedSize.width, height: resizedSize.height))

        let letterboxedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return letterboxedImage
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
