import Foundation
import FirebaseAuth
import FirebaseFirestore
import SwiftUI
import FirebaseCore
import FirebaseDynamicLinks
import FirebaseDatabase
import SocketIO

//var viewmodel: OnlineGameObject = OnlineGameObject

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
    
    @Published var winningType: ItemContent = .empty;
    @Published var items = Array(repeating: GridItemView(), count: 9){ didSet {
        updateStringItems()
         isWon = checkForWinningCombination(grid: items)
    }}
    @Published var isWon = false
    @Published var circles = 0
    @Published var crosses = 0
    @Published var stringItems: [String] = Array(repeating: " ", count: 9)
    private var moveListener: ListenerRegistration?
    @Published var isCross = true;
    @Published var gameId: String = ""
    
    
    func createNewGame() {
        self.gameId = UUID.init().uuidString
        socket.emit("join", [gameId])
    }
    func makeMove(atIndex index: Int) {
        socket.emit("move", MoveData(room: self.gameId, index: index))
        if items[index].changeState(newState: isCross ? .cross : .circle) {  if isCross { crosses = crosses + 1 } else { circles = circles + 1 }; print("crosses: \(crosses), circles: \(circles)") }
        
    }
    
    
    func joinGame(gameId: String){
        self.gameId = gameId
        socket.emit("join", [gameId])
    }
    
    init() {
        socket.on("updateGame") { data, _ in
            print(data)
            let jsonString =
           """
                                    \(data)
                                    """

            let jsonData = jsonString.data(using: .utf8)! // Unwrap assuming valid UTF-8
            do {
                    let games = try JSONDecoder().decode([Game].self, from: jsonData)
                    print(games)
                if games.first?.currentPlayer == 1{
                    self.isCross = true
                }
                else{
                    self.isCross = false
                }
                
                guard let items_ = games.first?.board else {return}
                for i in 0...8{
                    if items_[i] == nil{
                        self.items[i] = GridItemView(state: .empty)
                    }
                    if items_[i] == 0{
                        self.items[i] = GridItemView(state: .cross)
                    }
                    if items_[i] == 1{
                        self.items[i] = GridItemView(state: .circle)
                    }
                    
                }
            
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            
            
            for i in self.items{
                print(i.state)
                
            }
            print(self.isCross)
        }
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }
        
        socket.on("message") {data, ack in
            print("message", data)
        }
        socket.on("gameUpdate") {data, ack in
            print("message", data)
        }
        
        socket.connect()
    }
    
    private func updateStringItems() {
        stringItems = items.map { $0.description }
    }
    func resetGame(){
        items = Array(repeating: GridItemView(), count: 9)
        crosses = 0
        circles = 0
        isCross = true
        print("reseting game")
        
    }
    
    func checkForWinningCombination(grid: [GridItemView]) -> Bool {
        for row in 0 ..< 3 {
            if checkWinningRow(grid: grid, row: row) {
                return true
            }
        }
        for col in 0 ..< 3 {
            if checkWinningColumn(grid: grid, col: col) {
                return true
            }
        }
        if checkWinningDiagonal(grid: grid) {
            return true
        }
        
        return false
    }
    
    func checkWinningRow(grid: [GridItemView], row: Int) -> Bool {
        let item1 = grid[row * 3]
        let item2 = grid[row * 3 + 1]
        let item3 = grid[row * 3 + 2]
        
        if isSameType(item1: item1, item2: item2, item3: item3){
            winningType = item1.getState()
            return true
        }
        return isSameType(item1: item1, item2: item2, item3: item3)
    }
    
    func checkWinningColumn(grid: [GridItemView], col: Int) -> Bool {
        let item1 = grid[col]
        let item2 = grid[3 + col]
        let item3 = grid[6 + col]
        if isSameType(item1: item1, item2: item2, item3: item3){
            winningType = item1.getState()
            return true
        }
        return isSameType(item1: item1, item2: item2, item3: item3)
    }
    
    func checkWinningDiagonal(grid: [GridItemView]) -> Bool {
        let item1 = grid[0]
        let item2 = grid[4]
        let item3 = grid[8]
        
        let item1_ = grid[2]
        let item2_ = grid[4]
        
        if isSameType(item1: item1, item2: item2, item3: item3) || isSameType(item1: item1_, item2: item2_, item3: grid[6]){
            winningType = item2.getState()
            return true
        }
        
        return isSameType(item1: item1, item2: item2, item3: item3) || isSameType(item1: item1_, item2: item2_, item3: grid[6])
    }
    
    func isSameType(item1: GridItemView, item2: GridItemView, item3: GridItemView) -> Bool {
        if item1.state == item2.state && item2.state == item3.state && item1.state != .empty {
            return true
        }
        
        return false
    }
    func decodeToGridItemView(dictionary: [String: Any]) -> [GridItemView] {
        guard let board = dictionary["board"] as? [Any] else {
            return []
        }
        
        var gridItems = [GridItemView]()
        
        for item in board {
            if let content = item as? String {
                switch content {
                case "<null>":
                    gridItems.append(GridItemView(state: .empty))
                case "x":
                    gridItems.append(GridItemView(state: .cross))
                case "o":
                    gridItems.append(GridItemView(state: .circle))
                default:
                    gridItems.append(GridItemView(state: .empty))
                }
            } else if let content = item as? Int {
                switch content {
                case 0:
                    gridItems.append(GridItemView(state: .cross))
                case 1:
                    gridItems.append(GridItemView(state: .circle))
                default:
                    gridItems.append(GridItemView(state: .empty))
                }
            } else {
                gridItems.append(GridItemView(state: .empty))
            }
        }
        
        return gridItems
    }

    func extractBoard(from object: [[String: Any]]) -> [GridItemView] {
        guard let boardDict = object.first?["board"] as? [Any] else {
            return []
        }
        
        var gridItems = [GridItemView]()
        
        for item in boardDict {
            if let stringValue = item as? String {
                switch stringValue {
                case "<null>":
                    gridItems.append(GridItemView(state: .empty))
                case "x":
                    gridItems.append(GridItemView(state: .cross))
                case "o":
                    gridItems.append(GridItemView(state: .circle))
                default:
                    gridItems.append(GridItemView(state: .empty))
                }
            } else if let intValue = item as? Int {
                switch intValue {
                case 0:
                    gridItems.append(GridItemView(state: .cross))
                case 1:
                    gridItems.append(GridItemView(state: .circle))
                default:
                    gridItems.append(GridItemView(state: .empty))
                }
            } else {
                gridItems.append(GridItemView(state: .empty))
            }
        }
        
        return gridItems
    }
}
