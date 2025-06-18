//
//  ResultPage.swift
//  Acnesight
//
//  Created by Vira Fitriyani on 16/06/25.
//

import SwiftUI

struct ResultPage: View {
    let image: UIImage?
    let detections: [BoundingBox]

    @State private var selectedType: AcneType? = nil
    @State private var showDetails = false

    var body: some View {
        VStack(spacing: 0) {
            if let image = image {
                ZStack(alignment: .topLeading) {
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
                                .scaledToFill()
                                .frame(width: geoSize.width, height: geoSize.height)
                                .position(x: geoSize.width / 2, y: geoSize.height / 2)

                            ForEach(detections) { box in
                                if let type = box.type {
                                    let rect = box.rect
                                    let rectX = xOffset + rect.origin.x * displaySize.width
                                    let rectY = yOffset + (1 - rect.origin.y - rect.height) * displaySize.height
                                    let rectWidth = rect.width * displaySize.width
                                    let rectHeight = rect.height * displaySize.height

                                    ZStack(alignment: .topLeading) {
                                        Rectangle()
                                            .stroke(type.color, lineWidth: 2)
                                            .frame(width: rectWidth, height: rectHeight)

                                        Text(type.shortDescription)
                                            .font(.caption2).bold()
                                            .padding(4)
                                            .background(type.color)
                                            .foregroundColor(.white)
                                            .cornerRadius(5)
                                            .offset(x: 0, y: -20)
                                    }
                                    .position(x: rectX + rectWidth / 2, y: rectY + rectHeight / 2)
                                }
                            }
                        }
                    }
                    .frame(maxHeight: .infinity)
                }

                // Modal section
                VStack(spacing: 16) {
                    Text("You’re likely to have these in your face:")
                        .font(.headline)
                        .padding(.trailing, 50)

                    HStack(spacing: 16) {
                        ForEach(Array(Set(detections.compactMap { $0.type })), id: \.self) { type in
                            Button {
                                selectedType = type
                                showDetails = true
                            } label: {
                                VStack(spacing: 4) {
                                    Text(type.shortDescription)
                                        .font(.caption).bold()
                                        .padding(8)
                                        .background(type.color)
                                        .foregroundColor(.white)
                                        .clipShape(Circle())

                                    Text(type.rawValue)
                                        .font(.caption2)
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Get to know your acne")
                            .bold()

                        Text("Learn the difference between each type of acne and what you can do about it")
                            .font(.caption)

                        HStack {
                            Spacer()
                            Button("See all result") {
                                // Navigate to full results
                            }
                            .font(.caption)
                            .foregroundColor(.orange)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 4)

                    Text("This is an estimated result and may not reflect an exact diagnosis")
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)

                    Button("Finish") {
                        // Finish action
                    }
                    .font(.system(size: 20)).bold()
                    .padding()
                    .frame(maxWidth: 335, maxHeight: 58)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(20)
            }
        }
        .sheet(isPresented: $showDetails) {
//            ResultDetailView(detectedTypes: detectedTypes)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct ResultPage_Previews: PreviewProvider {
    static var previews: some View {
        let sampleImage = UIImage(named: "dummyy")!
        let sampleDetections = [
            BoundingBox(
                label: "pustule",
                confidence: 0.87,
                rect: CGRect(x: 0.01, y: 0.3, width: 0.2, height: 0.1)
            ),
            BoundingBox(
                label: "nodule",
                confidence: 0.92,
                rect: CGRect(x: 0.9, y: 0.45, width: 0.2, height: 0.1)
            ),
            BoundingBox(
                label: "blackhead",
                confidence: 0.92,
                rect: CGRect(x: 0.45, y: 0.4, width: 0.15, height: 0.2)
            )
        ]
        return ResultPage(image: sampleImage, detections: sampleDetections)
    }
}

//#Preview {
//    ResultPage(image: UIImage(systemName: "photo")!, detections: [])
//}
