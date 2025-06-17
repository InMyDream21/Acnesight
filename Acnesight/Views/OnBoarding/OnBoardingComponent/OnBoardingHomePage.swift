//
//  OnBoardingHomePage.swift
//  Acnesight
//
//  Created by Gede Binar on 17/06/25.
//


import SwiftUI

struct OnBoardingHomePage : View {
    private let textList : [String] = [
        "Please stand in front of good natural light",
        "Point out the camera to your acne",
        "Do not wear makeup or accessories"
    ]
    var body: some View {
        VStack(spacing:20){
            VStack {
                Image("GetStartedAsset")
                    .resizable()
                    .scaledToFit()
            }
            .frame(width: 205,height: 205)
            .background(.white)
            .clipShape(Ellipse())
            .overlay(
                    Ellipse()
                        .stroke(Color("SecondaryColor"), lineWidth: 14)
                )
            
            
            Text("Time for a selfie")
                .font(.largeTitle)
                .bold()
                .foregroundStyle(.white)
            VStack (alignment:.leading,spacing:20){
                ForEach(textList, id: \.self) {txt in
                    HStack(spacing:14){
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundStyle(Color("OliveGreen"))
                        Text(txt)
                            .font(.footnote)
                        
                    }
                }
            }
//            .frame(maxWidth: .infinity)
            .padding(.vertical,20)
            .padding(.horizontal,24)
            .background(.white)
            .cornerRadius(12)
        }
    }
}

#Preview {
    OnBoardingHomePage()
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(Color("PrimaryColor"))
}
