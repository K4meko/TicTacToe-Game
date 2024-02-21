//
//  SwiftUIView.swift
//  TicTacToe Game
//
//  Created by Eliška Pavlů on 04.01.2024.
//

import SwiftUI

struct SignInView: View {
    @Binding var isSigned: Bool
    @Binding var showBoard: Bool
    var body: some View {
        NavigationStack{
            VStack(alignment: .center){
                Text("Click below to generate your ID for your online game!").padding(.horizontal, 75)
                
                Spacer().frame(height: 40)
                
                Button(action: {
                    isSigned = true
                }, label:{
                    Text("Sign in").shadow(color: .red, radius: 10)
                    
                }).frame(width: 250, height: 60).foregroundStyle(.white).background(.orange).clipShape(RoundedRectangle(cornerRadius: 10))
            }.frame(height: 500)}}
}

//#Preview {
//    SignInView()
//}
