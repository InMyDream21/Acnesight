//
//  HomeView.swift
//  LearnMachineLearningSwift
//
//  Created by Gede Binar on 14/06/25.
//

import SwiftUI



struct HomeView: View {
    @Environment(Router.self) var router
    var body: some View {
        VStack(spacing:0) {
            Spacer()
            
            Image("HomePageLogoAsset")
                .resizable()
                .scaledToFit()
                .frame(width: 158,height: 157)
                .padding(.bottom)
            
            Image("HomepageAsset")
                .resizable()
                .scaledToFit()
                .padding(.vertical,32)
                
            
            VStack(spacing:0 ){
                VStack(){
                    HomeButton(
                        text:"START",
                        onClick: {router.navigateToCapture()},
                        isSecondary: true
                    )
                        .cornerRadius(50)
                }
                .padding(.top,30)
                .padding(.horizontal,30)
                .background(Color("PrimaryColor"))
                .clipShape(
                    .rect(
                        topLeadingRadius: 48,
                        topTrailingRadius: 48
                    )
                )
                VStack {
                    Text("Find out what type of acne you're dealing with")
                        .font(.title3)
                        .foregroundStyle(.white)
                        .bold()
                        .multilineTextAlignment(.center)
                        
                }
                .frame(maxWidth: .infinity,maxHeight: 100)
                .background(Color("PrimaryColor"))
            }
            
            
        }
    }
}

#Preview {
    HomeView()
        .environment(Router())
}
