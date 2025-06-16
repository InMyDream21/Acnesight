//
//  RouterView.swift
//  LearnMachineLearningSwift
//
//  Created by Gede Binar on 16/06/25.
//

import SwiftUI

struct RouterView: View {
    @State private var router = Router()
    
    private func routeView(for route:Route) -> some View {
        Group{
            switch route {
            case .home:
                VStack{}
            case .onboarding:
                VStack{}
            case .capture:
                VStack{}
            case .result(let resultInfo):
                VStack{}
            case .resultDetail:
                VStack{}
            }
        }
        .environment(router)
    }
    var body: some View {
        NavigationStack (path: $router.path){
            VStack{} // ganti root
//            HomeView()
                .environment(router)
                .navigationDestination(for: Route.self) { route in
                    routeView(for: route)
                }
        }
    }
}

//#Preview {
//    RouterView()
//}
