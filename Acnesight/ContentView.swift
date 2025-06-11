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

struct BoundingBox: Identifiable {
    let id = UUID()
    let label: String
    let confidence: Float
    let rect: CGRect
}

struct ContentView: View {
    @State private var showCamera = false
    @State private var inputImage: UIImage?
    @State private var detectedBoxes: [BoundingBox] = []
    
    var body: some View {
        ZStack {
            if let image = inputImage {
                GeometryReader { geo in
                    let imageSize = image.size
                    let geoSize = geo.size
                    let scale = min(geoSize.width / imageSize.width, geoSize.height / imageSize.height)
                    
                    let displaySize = CGSize(width: imageSize.width * scale, height: imageSize.height * scale)
                    let xOffset = (geoSize.width - displaySize.width) / 2
                    let yOffset = (geoSize.height - displaySize.height) / 2
                    
                    ZStack {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: displaySize.width, height: displaySize.height)
                            .position(x: geoSize.width / 2, y: geoSize.height / 2)
                        
                        ForEach(detectedBoxes) { box in
                            let rect = box.rect
                            
                            let rectX = xOffset + rect.origin.x * displaySize.width
                            let rectY = yOffset + (1 - rect.origin.y - rect.height) * displaySize.height
                            let rectWidth = rect.width * displaySize.width
                            let rectHeight = rect.height * displaySize.height
                            
                            ZStack(alignment: .topLeading) {
                                Rectangle()
                                    .stroke(Color.red, lineWidth: 2)
                                    .frame(width: rectWidth, height: rectHeight)

                                Text("\(box.label) \(Int(box.confidence * 100))%")
                                    .font(.caption)
                                    .padding(4)
                                    .background(Color.black.opacity(0.7))
                                    .foregroundColor(.white)
                                    .cornerRadius(4)
                                    .offset(x: 0, y: -20) // Move label above the box
                            }
                            .position(x: rectX + rectWidth / 2, y: rectY + rectHeight / 2)
                        }
                    }
                }
            } else {
                Text("Take a photo to start")
            }
            
            VStack {
                Spacer()
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
                .padding()
            }
        }
        .sheet(isPresented: $showCamera) {
            ImagePicker(image: $inputImage, onImagePicked: processImage)
        }
    }
    
    func processImage(_ image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        
        do {
            let config = MLModelConfiguration()
            let model = try AcneModel(configuration: config).model
            let vnModel = try VNCoreMLModel(for: model)
            
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
                    }
                }
            }
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            try handler.perform([request])
        } catch {
            print("Model failed: \(error)")
        }
    }
}
