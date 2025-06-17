//
//  WelcomingPage.swift
//  Acnesight
//
//  Created by Gede Binar on 17/06/25.
//

import SwiftUI

struct WelcomingPage : View {
    var body: some View {
        VStack (spacing:20){
            Text("Welcome to Acnesight!")
                .font(.title2)
                .bold()
            Image("OnBoardingAsset")
                .resizable()
                .scaledToFit()
                .frame(height: 237.78)
            VStack(spacing:10) {
                Text("Know Your Acne, Treat It Right")
                    .bold()
                    .font(.body)
                Text("Find out exactly what kind of acne you are dealing with and take the right step for a healthy skin.")
                    .multilineTextAlignment(.center)
                //                    .bold()
                    .padding(.horizontal,36)
                    .font(.callout)
                
            }
        }
    }
}

#Preview {
    WelcomingPage()
}
