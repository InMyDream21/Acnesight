//
//  AcnesightApp.swift
//  Acnesight
//
//  Created by Ahmed Nizhan Haikal on 11/06/25.
//

import SwiftUI

@main
struct AcnesightApp: App {
    @StateObject var cameraController = CameraController()
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(named:"PrimaryColor")
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
    }
    
    var body: some Scene {
        WindowGroup {
//            ContentView()
            RouterView()
                .environmentObject(cameraController)
        }
    }
}
