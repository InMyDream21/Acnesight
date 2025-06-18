//
//  OnBoardingView.swift
//  LearnMachineLearningSwift
//
//  Created by Gede Binar on 14/06/25.
//

import SwiftUI


struct OnBoardingView : View {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding = false
    @Environment(Router.self) var router
    @StateObject var viewModel : OnBoardingViewModel = OnBoardingViewModel()
    @StateObject var pickerViewModel: ImagePickerViewModel = ImagePickerViewModel()
    @State private var isShowingCamera = false
    @State private var inputImage: UIImage? = nil
    @State private var showCameraConfirmDialog = false
    
    init() {
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color("SecondaryColor"))
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(Color("PageIndicator"))
    }
    var body: some View {
        if viewModel.isGettingStarted {
            ZStack{
                OnBoardingHomePage()
                OnBoardingButton(
                    text: "TAKE A SELFIE",
                    onClick: {
                        hasSeenOnboarding = true
                        isShowingCamera = true
                    },isSecondary: true)
                    .frame(maxHeight: .infinity,alignment: .bottom)
            }
            .padding(.horizontal,30)
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            .background(Color("PrimaryColor"))
            .fullScreenCover(isPresented: $isShowingCamera) {
                ImagePicker { image in
                    inputImage = image
                    isShowingCamera = false
                    
                    pickerViewModel.processImage(image) { boxes in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            router.navigateToResult(image, boxes)
                        }
                    }
                }
                .ignoresSafeArea()
            }
        } else {
            VStack {
                TabView(selection:$viewModel.currentPage){
                    ForEach(0..<2){ index in
                        if index == 0 {
                            WelcomingPage()
                        }
                        if index == 1 {
                            DisclamerPage()
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                if viewModel.currentPage == 0 {
                    OnBoardingButton(text: "Next",onClick: {
                        withAnimation(.easeInOut){
                            viewModel.onClick_Next()
                        }  
                    }).padding(.vertical,8)
                } else if viewModel.currentPage == 1 {
                    OnBoardingButton(text: "Get Started",onClick: {
                        viewModel.onClick_GetStarted()
                        router.GettingStarted()
                    })
                        .padding(.vertical,8)
                }
                
            }
            .transition(.move(edge: .leading))
            .padding(.horizontal,30)
        }
    }
}


#Preview {
    OnBoardingView()
        .environment(Router())
}
