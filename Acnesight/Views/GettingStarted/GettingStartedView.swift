//
//  GettingStartedView.swift
//  Acnesight
//
//  Created by Gede Binar on 18/06/25.
//

import SwiftUI

struct GettingStartedContent : View {
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

struct GettingStartedView: View {
    @Environment(Router.self) var router
    var body: some View {
        ZStack{
            GettingStartedContent()
            OnBoardingButton(
                text: "TAKE A SELFIE",
                onClick: {
                    router.navigateToCapture()
                },isSecondary: true)
            .frame(maxHeight: .infinity,alignment: .bottom)
        }
        .padding(.horizontal,30)
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(Color("PrimaryColor"))
    }
}

#Preview {
    GettingStartedView()
        .environment(Router())
}
