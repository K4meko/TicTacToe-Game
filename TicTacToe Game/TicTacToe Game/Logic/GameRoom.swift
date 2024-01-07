import Foundation
import FirebaseFirestore
class GameRoom: ObservableObject {
    var id = UUID().uuidString
    private let firebaseFirestore = Firestore.firestore()
    var firebaseAuth: FirebaseAuthenticationService = FirebaseAuthenticationService()
    
    func sendMoveEvent(pleyerId: String, move:Int){
        
    }
}
