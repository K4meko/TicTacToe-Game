import Foundation
import SwiftUI

struct GameJoinView: View {
    @Binding var joined: Bool
    @State private var gameId: String = ""
    @StateObject var controller = GameController()

    var body: some View {
        VStack(alignment: .leading) {
            Text("To join a game, enter ID of game below").font(.title).bold()
            Text("Game ID can be found on the screen of the other player").font(.footnote).padding(.bottom, 90)
            VStack(alignment: .center){
                TextField("Enter Game ID", text: $gameId).textFieldStyle(.automatic).background().padding()
                Button("Join Game") {
                    if isValidGameId(gameId: gameId) {
                        // Join the game with the specified game ID
                        controller.joinGame(gameId: gameId){ success in
                            if success {
                                print("Successfully joined the game!")
                                joined = true;
                            } else {
                                print("Failed to join the game.")
                            }
                        }
                    } else {
                        // Display an error message if the game ID is invalid
                        print("Invalid game ID: \(gameId)")
                    }
                }.frame(width: 200, height: 60).background(.orange).clipShape(RoundedRectangle(cornerRadius: 10)).foregroundStyle(.white).padding(.top, 90)
            }
        }.background().padding()
    }

    private func isValidGameId(gameId: String) -> Bool {
        if(gameId.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            return false
        }
        return true
    }
}


