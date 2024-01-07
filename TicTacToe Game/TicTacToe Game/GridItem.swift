import SwiftUI

enum ItemContent {
    case cross
    case circle
    case empty
}
struct ToString: CustomStringConvertible {
    let gridItem: GridItemView

    var description: String {
        if gridItem.getState() == .circle {return "x"}
        if gridItem.getState() == .cross {return "o"}
        else {return " "}
    }
}

struct GridItemView: View {
    public var state: ItemContent = .empty
    @State private var icon: String? = nil
    @State var description: String = " "
    
    func getState() -> ItemContent{
        return self.state;
    }
    
    mutating func changeState(newState:ItemContent) -> Bool{
        if(self.state == .empty){
            self.state = newState;
            switch newState {
            case .circle:
                description = "x"
            case .cross:
                description = "o"
            case .empty:
                description = " "
            }
        return true}
        else{
            return false;
        }      
    }
    var body: some View {
        VStack {
            switch state {
            case .cross:
                Image(systemName: "xmark").resizable().foregroundStyle(.red)
            case .circle:
                Image(systemName: "circle").resizable().bold().foregroundStyle(.blue)
            case .empty:
                Text(" ")
            }
        }
        
        .onChange(of: state) { oldValue, newState in
            icon = nil
            switch newState {
            case .cross:
                icon = "xmark"
            case .circle:
                icon = "circle"
            case .empty:
                icon = nil
            }
        
        }
    }
}

