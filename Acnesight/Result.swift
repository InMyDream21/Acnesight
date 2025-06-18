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

struct Result: View {
    var data: ResultInfo
    
    var body: some View {
        ZStack {
            if let image = data.image {
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
                        
                        ForEach(data.bboxes) { box in
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
        }
    }
}
