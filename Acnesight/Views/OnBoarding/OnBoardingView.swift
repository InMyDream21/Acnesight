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
    @EnvironmentObject var cameraController: CameraController
    @State private var inputImage: UIImage? = nil
    
    init() {
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color("SecondaryColor"))
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(Color("PageIndicator"))
    }
    var body: some View {
        if false {
            ZStack{
                OnBoardingHomePage()
                OnBoardingButton(
                    text: "TAKE A SELFIE",
                    onClick: {
                        hasSeenOnboarding = true
                        cameraController.isShowingCamera = true
                    },isSecondary: true)
                    .frame(maxHeight: .infinity,alignment: .bottom)
            }
            .padding(.horizontal,30)
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            .background(Color("PrimaryColor"))
            
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
//                        viewModel.onClick_GetStarted()
                        router.navigateToGettingStarted()
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
