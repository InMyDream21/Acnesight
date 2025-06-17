//
//  HomeButton.swift
//  Acnesight
//
//  Created by Gede Binar on 17/06/25.
//

import SwiftUI

struct HomeButton: View {
    var text : String = "Click Here"
    var onClick : () -> Void = {}
    var isSecondary : Bool = false
    var body: some View {
        Button{
            onClick()
        } label: {
            VStack{
                Text(text)
                    .foregroundStyle(isSecondary ? Color("PrimaryColor") : .white)
                    .font(.title2)
                    .bold()
            }
            .frame(height: 58)
            .frame(maxWidth: .infinity)
            .background(isSecondary ?  .white : Color("PrimaryColor"))
            .cornerRadius(14)
        }
        
    }
}

#Preview {
    HomeButton()
}
