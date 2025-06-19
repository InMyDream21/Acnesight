//
//  RouterView.swift
//  LearnMachineLearningSwift
//
//  Created by Gede Binar on 16/06/25.
//

import SwiftUI

struct RouterView: View {
    @State private var router = Router()
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding = false
    
    private func routeView(for route:Route) -> some View {
        Group{
            switch route {
            case .home:
                HomeView()
            case .onboarding:
                OnBoardingView()
            case .result(let resultInfo):
                ResultPage(data: resultInfo)
                    .navigationBarBackButtonHidden(true)
            case .resultDetail(let acneTypes):
                ResultDetailView(detectedTypes: acneTypes)
                    .navigationBarBackButtonHidden(true)
            case .resource:
                ResourcePage()
                    .navigationBarBackButtonHidden(true)
            case .resultNotDetected(let image):
                ResultUndetected(image: image)
                    .navigationBarBackButtonHidden(true)
            case .gettingStarted:
                GettingStartedView()
            }
        
        }
        .environment(router)
    }
    var body: some View {
        NavigationStack (path: $router.path){
            Group {
                if hasSeenOnboarding{
                    HomeView()
                } else {
                    OnBoardingView()
                }
            }
                .environment(router)
                .navigationDestination(for: Route.self) { route in
                    routeView(for: route)
                }
        }
    }
}

#Preview {
    RouterView()
}
