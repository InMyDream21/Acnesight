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
    
    func navigateToHome() {
        path.append(Route.home)
    }
    
    func navigateToOnBoarding(){
        path.append(Route.onboarding)
    }
    
    func navigateToResult(_ image : UIImage, _ bboxes: [BoundingBox]) {
        path.append(Route.result(ResultInfo(image: image, bboxes: bboxes)))
    }
    
    func navigateBack () {
        path.removeLast()
    }
    
    func returnToRoot () {
        path = NavigationPath()
    }
}

struct ResultInfo : Hashable, Equatable {
    let id = UUID()
    let image : UIImage?
    let bboxes: [BoundingBox]
    
    static func == (lhs: ResultInfo, rhs: ResultInfo) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct ResultDetailInfo : Hashable,Equatable {
    
}

enum Route : Hashable, Equatable{
    case home
    case onboarding
    case capture
//    case result(ResultInfo)
//    case resultDetail
    case gettingStarted
}
