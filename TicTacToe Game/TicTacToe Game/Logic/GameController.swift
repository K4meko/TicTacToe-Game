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

struct MoveData : SocketData {
    let room: String
    let index: Int

    func socketRepresentation() -> SocketData {
        return ["room": room, "index": index]
    }
 }


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
        socket.emit("join", [gameId])
    }
    func makeMove(atIndex index: Int) {
        socket.emit("move", MoveData(room: self.gameId, index: index))
    }
    
    func joinGame(gameId: String){
        self.gameId = gameId
        socket.emit("join", [gameId])
    }
}
