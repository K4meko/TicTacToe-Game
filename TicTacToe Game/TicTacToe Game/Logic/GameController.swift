import Foundation
import FirebaseAuth
import FirebaseFirestore
import SwiftUI
import FirebaseCore
import FirebaseDynamicLinks

class GameController: ObservableObject {
  

    private var moveListener: ListenerRegistration?
    let firestore = Firestore.firestore()
    @Published var gameModel: OnlineGameObject
    let firebaseAuth: FirebaseAuthenticationService
    let gameRoom: GameRoom
   

    init() {
        self.gameModel = OnlineGameObject()
        self.firebaseAuth = FirebaseAuthenticationService()
        self.gameRoom = GameRoom()
    }
    func makeMove(atIndex index: Int) {
        let userId = firebaseAuth.currentUser!.uid

            // Write the move to the database
            let moveRef = firestore.collection("games").document(gameModel.gameId)
                    .collection("moves").document(userId)

        let moveData = ["index": index, "timestamp": Date()] as [String : Any]
            moveRef.setData(moveData)
        // Check for wins
//        if gameModel.checkForWinningCombination(grid: gameModel.items ) {
//            // End the game
//            gameRoom.endGame(winnerId: userId)
//        } else if gameModel.isDraw() {
//            // End the game
//            gameRoom.endGame(tie: true)
//        }
    }


    func inviteUser(userId: String) async {
        // Create an invitation document
        let invitationRef = firestore.collection("games").document(gameModel.gameId)
                .collection("invitations").document(userId)

       
    }

    func createNewGame() {
       
        let newGameRef = firestore.collection("games").document("OtI8iGOz81pGTpmfo758"
        )//rewrite na documentID
        
        print("new game created")
        print(newGameRef.documentID)
        // Set the game's ID
        gameModel.gameId = newGameRef.documentID
        print(gameModel.gameId)
        newGameRef.updateData(["players": [Auth.auth().currentUser?.uid]]) { error in
            if let error = error {
                print("Error adding player to game: \(error)")
                return
            }
        }
    }
    func startListeningForMoves() {
        let gameRef = firestore.collection("games").document(gameModel.gameId)
                    .collection("moves")
        moveListener = gameRef.addSnapshotListener { [self] snapshot, error in
            guard let snapshot = snapshot else {
                return
            }

            for document in snapshot.documents {
                let moveData = document.data()
                let userId = document.documentID
                let index = moveData["index"] as! Int

                print("Received move from user \(userId): \(index)")

                // Update the game state on the client-side
                gameModel.makeMove(index)
            }
        }
    }
   
    func joinGame(gameId: String) {
        let newGameRef = Firestore.firestore().collection("games").document("OtI8iGOz81pGTpmfo758")

                   // Use FieldValue.arrayUnion to add a new player to the "players" array
        newGameRef.updateData(["players": FieldValue.arrayUnion([Auth.auth().currentUser?.uid])]) { error in
                       if let error = error {
                           print("Error adding player to game: \(error)")
                       } else {
                           print("Player added to the game successfully")
                       }
                   }
    }
}
