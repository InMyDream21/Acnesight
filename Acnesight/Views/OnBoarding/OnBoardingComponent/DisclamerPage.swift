//
//  DisclamerPage.swift
//  Acnesight
//
//  Created by Gede Binar on 17/06/25.
//

import SwiftUI

struct DisclaimerItem : Identifiable {
    let id : UUID = UUID()
    let iconName : String
    let text : String
}



struct DisclamerPage : View {
    
    private let disclaimerItems : [DisclaimerItem] = [
        DisclaimerItem(
            iconName: "stethoscope",
            text: "This app is not a medical tool and does not provide professional diagnosis."
        ),
        DisclaimerItem(
            iconName: "desktopcomputer",
            text: "The acne detection feature is powered by machine learning and serves only as a visual aid to help you identify visible acne types based on your selfie."
        ),
        DisclaimerItem(
            iconName: "bandage",
            text: "For any treatment decisions or concerns, always consult with a dermatologist or licensed healthcare provider"
        ),
        DisclaimerItem(
            iconName: "camera",
            text: "We do not store any photos you take"
        ),
    ]
    
    var body: some View {
        VStack(alignment:.leading,spacing:30) {
            Text("Disclaimer")
                .font(.largeTitle)
                .bold()
            VStack(alignment:.center,spacing:25){
                Group{
                    HStack {
                        Text("Please read before you continue using our app")
                        Spacer()
                    }
                    VStack (alignment:.leading,spacing:20){
                        Group {
                            ForEach(disclaimerItems) {item in
                                HStack(spacing:15){
                                    Image(systemName: item.iconName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 24, height: 24)
                                        .foregroundStyle(Color("Green"))
//
//                                    JustifiedText(text: item.text)
////                                        .padding(0)
                                    Text(item.text)
                                        
                                }
                                
                            }
                            
                        }
                        .padding(.horizontal,14)
                    }
                    HStack {
                        Text("By continuing, you agree to our Terms of Service and Privacy Policy.")
                        Spacer()
                    }
                }
                .font(.subheadline)
                
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal,15)
            .padding(.vertical,10)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.primary, lineWidth: 1)
            )
            .padding(.horizontal,4)
                        Spacer()
                
        }
        .padding(.top,30)
    }
}

struct JustifiedText: UIViewRepresentable {
    var text: String
    var fontSize : CGFloat = 16
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.text = text
        textView.textAlignment = .justified
        textView.font = .systemFont(ofSize: fontSize)
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        
    }
}

#Preview {
    DisclamerPage()
}
