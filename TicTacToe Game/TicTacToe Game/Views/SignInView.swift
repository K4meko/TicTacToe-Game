//
//  SwiftUIView.swift
//  TicTacToe Game
//
//  Created by Eliška Pavlů on 04.01.2024.
//

import SwiftUI
import FirebaseAuth

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
                    
                }).frame(width: 250, height: 60).foregroundStyle(.white).background(.orange).clipShape(RoundedRectangle(cornerRadius: 10)).onTapGesture {
                    Task {
                        do {
                            try Auth.auth().signInAnonymously()
                            print(Auth.auth().currentUser?.uid ?? "user id null")
                        } catch {
                            print("Error signing in: \(error)")
                        }
                        // Completion handler
                        DispatchQueue.main.async {
                            print("Completion handler executed")
                        }
                    }
                    
                    
                }
            }.frame(height: 500)}}
}

//#Preview {
//    SignInView()
//}
