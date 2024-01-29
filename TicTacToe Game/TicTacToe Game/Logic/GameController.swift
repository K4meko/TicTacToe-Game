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
    @State var gameModel = viewmodel;
    private var moveListener: ListenerRegistration?
    let firestore = Firestore.firestore()
    let firebaseAuth: FirebaseAuthenticationService
  //  @State var gameModel = viewmodel
    let gameRoom: GameRoom
    var isCross = true;
    @Published var gameId:String = ""
    
    func createNewGame() {
        self.gameId = UUID.init().uuidString
        socket.on("message") {data, ack in
            print("message", data)
        }
        socket.emit("join", ["1234"])
        let userId = Auth.auth().currentUser?.uid ?? " "
        let newGameRef = firestore.collection("games").document(gameId)
        let data: [String: Any] = [
            "Game Id": gameId,
            "Players": [userId],
            "Current player is cross": isCross
        ]
        let gamesCollection = firestore.collection("games")

        // Fetch documents from the collection
        gamesCollection.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                // Iterate through the documents in the snapshot
                for document in querySnapshot!.documents {
                    // Print the data of each document
                   // print("\(document.documentID) => \(document.data())")
                    
                }
            }
        }
        
        newGameRef.setData(data, merge: false){ error in
            if let error = error {
                print("Error setting document data: \(error)")
            } else {
                print("Document with ID \(self.gameId) successfully set.")
            }
        }
        print("game path is: \(newGameRef.path)")
        print(gameId)    }
    func startListeningForMoves() {
        let gameRef = firestore.collection("games").document(gameId)
            .collection("moves")
        moveListener = gameRef.addSnapshotListener {snapshot, error in
            if let error = error{
                print(error)
                return
            }
            guard let snapshot = snapshot else {
                return
            }
            
            for document in snapshot.documents {
                let moveData = document.data()
                _ = document.documentID
                let index = moveData["index"] as! Int
                
                //print("Received move from user \(userId): \(index)")
                
                self.gameModel.makeMove(index)
                self.makeMove(atIndex: index)
            }
        }
    }
    
    init() {
        print("init")
        self.firebaseAuth = FirebaseAuthenticationService()
        self.gameRoom = GameRoom()
        
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }
        
        socket.connect()
    }
    func makeMove(atIndex index: Int) {
        let data: [String: Any] = ["Current player is cross" : false]
        let data2: [String: Any] = ["index": index, "player:" : Auth.auth().currentUser?.uid ?? "empty"]
        
      //  _ = firebaseAuth.currentUser!.uid
        
        
        // Write the move to the database
        let moveRef = firestore.collection("games").document(gameId)
            .collection("moves").document(Auth.auth().currentUser!.uid)
        moveRef.setData(data2)
        
        let moveData = ["index": index, "timestamp": Date()] as [String : Any]
        moveRef.setData(moveData)
        let newGameRef = firestore.collection("games").document(gameId)
        newGameRef.updateData(data)
        // Check for wins
        //        if gameModel.checkForWinningCombination(grid: gameModel.items ) {
        //            // End the game
        //            gameRoom.endGame(winnerId: userId)
        //        } else if gameModel.isDraw() {
        //            // End the game
        //            gameRoom.endGame(tie: true)
        //        }
    }
    
    func joinGame(gameId: String, completion: @escaping (Bool) -> Void) {
        let newGameRef = Firestore.firestore().collection("games").document(gameId)

        newGameRef.getDocument { (document, error) in
            DispatchQueue.main.async {
                if let document = document, document.exists {
                    print(gameId)
                    print("doc exists")
                    let players = document.data()?["Players"] as? [String] ?? []
                    let count = players.count

                    // Check if there are less than two players
                    print("Document path: \(newGameRef.path)")

                    if count < 2 {
                        if let uid = Auth.auth().currentUser?.uid {
                            newGameRef.updateData(["Players": FieldValue.arrayUnion([uid])]) { error in
                                if let error = error {
                                    print("Error adding player to game: \(error)")
                                    completion(false)
                                } else {
                                    print("Player added to the game successfully")
                                    completion(true)
                                }
                            }
                        } else {
                            print("No authenticated user")
                            completion(false)
                        }
                    } else {
                        print("Game is already full")
                        completion(false)
                    }
                } else {
                    print(gameId)
                    print("Document doesn't exist \(error?.localizedDescription ?? "Unknown error")")
                    completion(false)
                }
                if let error = error {
                    print("Error accessing game document: \(error.localizedDescription)")
                    completion(false)
                    return
                }
            }
        }
    }

}
