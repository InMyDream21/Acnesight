//
//  GettingStartedView.swift
//  Acnesight
//
//  Created by Gede Binar on 18/06/25.
//

import SwiftUI

struct GettingStartedContent : View {
    private let textList : [String] = [
        "Please stand in front of good natural light",
        "Point out the camera to your acne",
        "Do not wear makeup or accessories"
    ]
    var body: some View {
        VStack(spacing:20){
            VStack {
                Image("GetStartedAsset")
                    .resizable()
                    .scaledToFit()
            }
            .frame(width: 205,height: 205)
            .background(.white)
            .clipShape(Ellipse())
            .overlay(
                Ellipse()
                    .stroke(Color("GettingStartedBorder"), lineWidth: 14)
            )
            
            
            Text("Time for a selfie")
                .font(.largeTitle)
                .bold()
                .foregroundStyle(.white)
            VStack (alignment:.leading,spacing:20){
                ForEach(textList, id: \.self) {txt in
                    HStack(spacing:14){
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundStyle(Color("OliveGreen"))
                        Text(txt)
                            .font(.footnote)
                            .foregroundStyle(.black)
                    }
                }
            }
            //            .frame(maxWidth: .infinity)
            .padding(.vertical,20)
            .padding(.horizontal,24)
            .background(.white)
            .cornerRadius(12)
        }
    }
}

struct GettingStartedView: View {
    @Environment(Router.self) var router
    @StateObject var pickerViewModel: ImagePickerViewModel = ImagePickerViewModel()
    @EnvironmentObject var cameraController: CameraController
    @State private var inputImage: UIImage? = nil
    
    var body: some View {
        ZStack{
            GettingStartedContent()
            OnBoardingButton(
                text: "TAKE A SELFIE",
                onClick: {
                    cameraController.isShowingCamera = true
                },isSecondary: true)
            .frame(maxHeight: .infinity,alignment: .bottom)
        }
        .padding(.horizontal,30)
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(Color("PrimaryColor"))
        .onAppear{
            router.hasSeenOnBoarding = true
        }
        .fullScreenCover(isPresented: $cameraController.isShowingCamera) {
            ImagePicker { image in
                inputImage = image
                cameraController.isShowingCamera = false
                pickerViewModel.processImage(image) { boxes in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        router.navigateToResult(image, boxes)
                    }
                }
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    GettingStartedView()
        .environment(Router())
}
