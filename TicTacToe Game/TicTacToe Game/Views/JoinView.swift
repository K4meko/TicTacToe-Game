import Foundation
import SwiftUI

struct GameJoinView: View {
    @EnvironmentObject var controller: GameController
    @Binding var gameId: String;
    @Binding var show: Bool;
    @Binding var showCircleView: Bool;

    var body: some View {
        VStack(alignment: .leading) {
            Text("To join a game, enter ID of game below").font(.title).bold()
            Text("Game ID can be found on the screen of the other player").font(.footnote).padding(.bottom, 90)
            VStack(alignment: .center){
                TextField("Enter Game ID", text: $gameId).textFieldStyle(.automatic).background().padding()
                Button("Join Game") {
                    if isValidGameId(gameId: gameId) {
                        // Join the game with the specified game ID
                        controller.joinGame(gameId: gameId)
                        showCircleView = true;
                        show = false
                        print("Successfully joined the game!")
                    
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


