//import SwiftUI
//import Foundation
//
//class OnlineGameObject: ObservableObject{
//   
//    @Published var winningType: ItemContent = .empty;
//    @Published var items = Array(repeating: GridItemView(), count: 9){ didSet {
//        updateStringItems()
//    }}
//   // @Published var isCross: Bool = controller.isCross
//    
//    @Published var circles = 0
//    @Published var crosses = 0
//    @Published var stringItems: [String] = Array(repeating: " ", count: 9)
//
//        
//    private func updateStringItems() {
//            stringItems = items.map { $0.description }
//        }
//    func resetGame(){
//        items = Array(repeating: GridItemView(), count: 9)
//        print("reseting game")
//        
//    }
//    func makeMove(_ index: Int){
//        if items[index].changeState(newState: controller.isCross ? .cross : .circle) {  if isCross { crosses = crosses + 1 } else { circles = circles + 1 }; print("crosses: \(crosses), circles: \(circles)") }
//    }
//    
//    func checkForWinningCombination(grid: [GridItemView]) -> Bool {
//        for row in 0 ..< 3 {
//            if checkWinningRow(grid: grid, row: row) {
//                return true
//            }
//        }
//        for col in 0 ..< 3 {
//            if checkWinningColumn(grid: grid, col: col) {
//                return true
//            }
//        }
//        if checkWinningDiagonal(grid: grid) {
//            return true
//        }
//        
//        return false
//    }
//    
//    func checkWinningRow(grid: [GridItemView], row: Int) -> Bool {
//        let item1 = grid[row * 3]
//        let item2 = grid[row * 3 + 1]
//        let item3 = grid[row * 3 + 2]
//        
//        if isSameType(item1: item1, item2: item2, item3: item3){
//            winningType = item1.getState()
//            return true
//        }
//        return isSameType(item1: item1, item2: item2, item3: item3)
//    }
//    
//    func checkWinningColumn(grid: [GridItemView], col: Int) -> Bool {
//        let item1 = grid[col]
//        let item2 = grid[3 + col]
//        let item3 = grid[6 + col]
//        if isSameType(item1: item1, item2: item2, item3: item3){
//            winningType = item1.getState()
//            return true
//        }
//        return isSameType(item1: item1, item2: item2, item3: item3)
//    }
//    
//    func checkWinningDiagonal(grid: [GridItemView]) -> Bool {
//        let item1 = grid[0]
//        let item2 = grid[4]
//        let item3 = grid[8]
//        
//        let item1_ = grid[2]
//        let item2_ = grid[4]
//        
//        if isSameType(item1: item1, item2: item2, item3: item3) || isSameType(item1: item1_, item2: item2_, item3: grid[6]){
//            winningType = item2.getState()
//            return true
//        }
//        
//        return isSameType(item1: item1, item2: item2, item3: item3) || isSameType(item1: item1_, item2: item2_, item3: grid[6])
//    }
//    
//    func isSameType(item1: GridItemView, item2: GridItemView, item3: GridItemView) -> Bool {
//        if item1.state == item2.state && item2.state == item3.state && item1.state != .empty {
//            return true
//        }
//        
//        return false
//    }
//}
//
//
