import Foundation
import FirebaseAuth
import FirebaseFirestore
import SwiftUI
import FirebaseCore
import FirebaseDynamicLinks
import FirebaseDatabase
import SocketIO

var viewmodel: OnlineGameObject = OnlineGameObject()

let manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.log(false), .compress])
let socket = manager.defaultSocket


class GameController: ObservableObject {
    init() {
        self.gameRoom = GameRoom()
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }
        
        socket.on("message") {data, ack in
            print("message", data)
        }
        
        socket.connect()
    }
    @State var gameModel = viewmodel;
    private var moveListener: ListenerRegistration?
//    @State var gameModel = viewmodel
    let gameRoom: GameRoom
    var isCross = true;
    @Published var gameId: String = ""
    
    func createNewGame() {
        self.gameId = UUID.init().uuidString
        print(self.gameId)
        socket.emit("join", [gameId])
    }
    func makeMove(atIndex index: Int) {
        
    }
    
    func joinGame(gameId: String){
        //
    }
}
