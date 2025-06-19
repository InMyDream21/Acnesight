//
//  ResultPage.swift
//  Acnesight
//
//  Created by Vira Fitriyani on 16/06/25.
//

import SwiftUI

struct ResultPage: View {
    let data: ResultInfo
    @Environment(Router.self) var router

    @State private var selectedType: AcneType? = nil
    @State private var showDetails = false

    var body: some View {
        VStack(spacing: 0) {
            if let image = data.image {
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

                            ForEach(data.bboxes) {box in
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

                VStack(spacing: 16) {
                    Text("You’re likely to have these in your face:")
                        .font(.headline)
                        .padding(.trailing, 50)

                    HStack(spacing: 16) {
                        ForEach(Array(Set(data.bboxes.compactMap { $0.type })), id: \.self) { type in
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
                            .foregroundColor(.black)

                        Text("Learn the difference between each type of acne and what you can do about it")
                            .font(.caption)
                            .foregroundColor(.black)

                        HStack {
                            Spacer()
                            Button("See all result") {
                                // Navigate to full results
                                let types = Array(Set(data.bboxes.compactMap{ $0.type }))
                                router.navigateToResultDetail(types)
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
                        router.returnToRoot()
                    }
                    .font(.system(size: 20)).bold()
                    .padding()
                    .frame(maxWidth: 335, maxHeight: 58)
                    .background(Color("PrimaryColor"))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(20)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

