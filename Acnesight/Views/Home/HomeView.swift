//
//  HomeView.swift
//  LearnMachineLearningSwift
//
//  Created by Gede Binar on 14/06/25.
//

import SwiftUI



struct HomeView: View {
    @Environment(Router.self) var router
    @State private var inputImage: UIImage?
    @State private var isShowingCamera = false
    @StateObject var viewModel: ImagePickerViewModel = ImagePickerViewModel()
    
    var body: some View {
        VStack(spacing:0) {
            Spacer()
            
            Image("HomePageLogoAsset")
                .resizable()
                .scaledToFit()
                .frame(width: 158,height: 157)
                .padding(.bottom)
            
            Image("HomepageAsset")
                .resizable()
                .scaledToFit()
                .padding(.vertical,32)
                
            
            VStack(spacing:0 ){
                VStack(){
                    HomeButton(
                        text:"START",
                        onClick: {isShowingCamera = true},
                        isSecondary: true
                    )
                        .cornerRadius(50)
                }
                .padding(.top,30)
                .padding(.horizontal,30)
                .background(Color("PrimaryColor"))
                .clipShape(
                    .rect(
                        topLeadingRadius: 48,
                        topTrailingRadius: 48
                    )
                )
                VStack {
                    Text("Find out what type of acne you're dealing with")
                        .font(.title3)
                        .foregroundStyle(.white)
                        .bold()
                        .multilineTextAlignment(.center)
                        
                }
                .frame(maxWidth: .infinity,maxHeight: 100)
                .background(Color("PrimaryColor"))
            }
        }
        .fullScreenCover(isPresented: $isShowingCamera) {
            ImagePicker { image in
                inputImage = image
                isShowingCamera = false
                
                viewModel.processImage(image) { boxes in
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
    HomeView()
        .environment(Router())
}
