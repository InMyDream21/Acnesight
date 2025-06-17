//
//  OnBoardingViewModel.swift
//  LearnMachineLearningSwift
//
//  Created by Gede Binar on 14/06/25.
//

import SwiftUI

class OnBoardingViewModel : ObservableObject {
    
    @Published var currentPage : Int = 0
    @Published var maxPage = 2
    @Published var isGettingStarted : Bool = false
    
    init(){
        
    }
    
    func isLastPage () -> Bool {
        return true
    }
    
    func onClick_Next(){
        if currentPage + 1 != maxPage {
            currentPage += 1
        }
    }
    
    func onClick_GetStarted () {
        isGettingStarted = true
    }
    
    func onClick_FinishedOnBoarding () {
        
    }
    
    func onClick_Back(){
        if currentPage != 1 {
            currentPage -= 1
        }
    }
    
    func onClick_Skip(){
        currentPage = maxPage - 1
    }
    
    
    
    
}
