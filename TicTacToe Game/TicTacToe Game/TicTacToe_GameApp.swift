//
//  TicTacToe_GameApp.swift
//  TicTacToe Game
//
//  Created by Eliška Pavlů on 28.12.2023.
//

import SwiftUI
import Firebase
import FirebaseAppCheck
import FirebaseCore

@main
struct TicTacToe_GameApp: App {
    init() {
            FirebaseApp.configure()
        }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
