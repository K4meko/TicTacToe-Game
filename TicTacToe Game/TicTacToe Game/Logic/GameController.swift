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

        //        print("init")
        //        self.firebaseAuth = FirebaseAuthenticationService()
        
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }
        
        socket.connect()
    }
    @State var gameModel = viewmodel;
    private var moveListener: ListenerRegistration?
//    let firestore = Firestore.firestore()
//    let firebaseAuth: FirebaseAuthenticationService
//    @State var gameModel = viewmodel
    let gameRoom: GameRoom
    var isCross = true;
    @Published var gameId:String = ""
    
    func createNewGame() {
        self.gameId = UUID.init().uuidString
        socket.on("message") {data, ack in
            print("message", data)
        }
        socket.emit("join", ["1234"])
//        let userId = Auth.auth().currentUser?.uid ?? " "
//                let newGameRef = firestore.collection("games").document(gameId)
//                let data: [String: Any] = [
//                    "Game Id": gameId,
//                    "Players": [userId],
//                    "Current player is cross": isCross
//                ]
//                let gamesCollection = firestore.collection("games")
// Fetch documents from the collection
//  gamesCollection.getDocuments { (querySnapshot, error) in
//            if let error = error {
//                print("Error getting documents: \(error)")
//            } else {
//                // Iterate through the documents in the snapshot
//                for document in querySnapshot!.documents {
//                    // Print the data of each document
//                    // print("\(document.documentID) => \(document.data())")
//                    
//                }
//            }
//        }
//        
//                newGameRef.setData(data, merge: false){ error in
//                    if let error = error {
//                        print("Error setting document data: \(error)")
//                    } else {
//                        print("Document with ID \(self.gameId) successfully set.")
//                    }
//                }
//                print("game path is: \(newGameRef.path)")
//                print(gameId)    }
    }
    func makeMove(atIndex index: Int) {
//            let data: [String: Any] = ["Current player is cross" : false]
//            let data2: [String: Any] = ["index": index, "player:" : Auth.auth().currentUser?.uid ?? "empty"]
//
//              _ = firebaseAuth.currentUser!.uid
//
//
//             Write the move to the database
//                    let moveRef = firestore.collection("games").document(gameId)
//                        .collection("moves").document(Auth.auth().currentUser!.uid)
//                    moveRef.setData(data2)
//
//                    let moveData = ["index": index, "timestamp": Date()] as [String : Any]
//                    moveRef.setData(moveData)
//                    let newGameRef = firestore.collection("games").document(gameId)
//                    newGameRef.updateData(data)
//             Check for wins
//                    if gameModel.checkForWinningCombination(grid: gameModel.items ) {
//                        // End the game
//                        gameRoom.endGame(winnerId: userId)
//                    } else if gameModel.isDraw() {
//                        // End the game
//                        gameRoom.endGame(tie: true)
//                    }
    }
    
    func joinGame(gameId: String){
        //
    }
}
