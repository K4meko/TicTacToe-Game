//
//  ContentView.swift
//  TicTacToe Game
//
//  Created by Eliška Pavlů on 28.12.2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var controller = GameController()
    var body: some View {
        VStack {
            PickView().environmentObject(controller)
        }
       
    }
}

#Preview {
    ContentView()
}
