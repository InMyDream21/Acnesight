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
    
    var body: some Scene {
        WindowGroup {
//            ContentView()
            RouterView()
                .environmentObject(cameraController)
        }
    }
}
