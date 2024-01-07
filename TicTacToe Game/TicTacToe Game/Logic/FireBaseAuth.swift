import Foundation
import Firebase
import FirebaseAuth
class FirebaseAuthenticationService: ObservableObject {
    
    @Published var currentUser: User?;
    @Published var auth: Auth
    
    init() {
        auth = Auth.auth()
        if let user =  auth.currentUser {currentUser = user
        }
        else{
            currentUser = nil;
        }
        

        func signUp(email: String, password: String) {
            auth.createUser(withEmail: email, password: password) { result, error in
                if error == nil {
                    // Sign up successful
                } else {
                    // Sign up failed
                }
            }
        }
        
        //    func signOut() {
        //        auth.signOut()
        //    }
    }
}
