//
//  Router.swift
//  LearnMachineLearningSwift
//
//  Created by Gede Binar on 16/06/25.
//

import Foundation
import SwiftUI
import Observation

@Observable
class Router  {
    var path = NavigationPath()
    
    private let defaults = UserDefaults.standard
    var hasSeenOnBoarding: Bool {
            get {
                defaults.bool(forKey: "hasSeenOnboarding")
            }
            set {
                defaults.set(newValue, forKey: "hasSeenOnboarding")
            }
        }
    
    var atGettingStarted : Bool = false
    
    func GettingStarted() {
        hasSeenOnBoarding = true
        atGettingStarted = true
    }
    
    func navigateToCapture() {
        path.append(Route.capture)
    }
    
    func naviagteToHome() {
        path.append(Route.home)
    }
    
    func navigateToOnBoarding(){
        path.append(Route.onboarding)
    }
    
    func navigateToResult(image : UIImage) {
        path.append(Route.result(ResultInfo(image: image)))
    }
    
    func navigateBack () {
        path.removeLast()
    }
    
    func returnToRoot () {
        path = NavigationPath()
    }
}

struct ResultInfo : Hashable,Equatable{
    let image : UIImage
}

struct ResultDetailInfo : Hashable,Equatable {
    
}

enum Route : Hashable, Equatable{
    case home
    case onboarding
    case capture
    case result(ResultInfo)
    case resultDetail
}
