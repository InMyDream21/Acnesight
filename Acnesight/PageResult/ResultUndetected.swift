//
//  ResultUndetected.swift
//  Acnesight
//
//  Created by Vira Fitriyani on 17/06/25.
//

import SwiftUI

struct ResultUndetected: View {
    let image: UIImage?
    @Environment(Router.self) var router
    @EnvironmentObject var cameraController: CameraController

    var body: some View {
        VStack(spacing: 0) {
            if let image = image {
                ZStack(alignment: .topLeading) {
                    GeometryReader { geo in
                        let imageSize = image.size
                        let geoSize = geo.size
                        let scale = min(geoSize.width / imageSize.width, geoSize.height / imageSize.height)
                        let displaySize = CGSize(width: imageSize.width * scale, height: imageSize.height * scale)
                        
                        ZStack {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: geoSize.width, height: geoSize.height)
                                .position(x: geoSize.width / 2, y: geoSize.height / 2)
                        }
                    }
                    .frame(maxHeight: .infinity)
                    
                    Button(action: {
                        router.returnToRoot()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.clear)
                            .overlay(
                                Circle().stroke(Color.white, lineWidth: 2)
                            )
                    }
                    .padding(.top, 5)
                    .padding(.leading, 20)
                }
                
                // Modal section
                VStack(spacing: 16) {
                    Label("We're unable to detect your acne", systemImage: "exclamationmark.triangle")
                        .font(.headline)
                        .foregroundColor(Color("PrimaryColor"))

                    VStack(alignment: .leading, spacing: 8) {
                        Text("For better result, try getting closer to your acne area and keep the camera steady. Avoid blurry image and low lighting.")
                            .font(.caption)
                            .multilineTextAlignment(.leading)
                    }
                    .padding()
                    
                    HStack {
                        Button(action: {
                            cameraController.isShowingCamera = true
                            router.returnToRoot()
                        }) {
                            Label("Retake", systemImage: "camera")
                        }
                        .padding()
                        .font(.system(size: 20)).bold()
                        .frame(maxWidth: 335, maxHeight: 58)
                        .background(Color("PrimaryColor"))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemBackground))
                .cornerRadius(20)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

//#Preview {
//    ResultUndetected(image: UIImage(named: "dummyy")!)
//}
