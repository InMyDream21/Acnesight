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
            case .capture:
                VStack{}
            case .result(let resultInfo):
                Result(data: resultInfo)
            case .resultDetail:
                VStack{}
            }
        }
        .environment(router)
    }
    var body: some View {
        NavigationStack (path: $router.path){
            Group {
                if hasSeenOnboarding && !router.atGettingStarted {
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
