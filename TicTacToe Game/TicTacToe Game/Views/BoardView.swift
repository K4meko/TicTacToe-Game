
import SwiftUI

struct BoardView: View {
    @StateObject var viewModel = BoardViewViewModel()
    @State var showAlert = false;
    @State var showTieAlert = false;

    var body: some View {
        VStack{
            Spacer().frame(height: 100)
        ZStack {
            LazyVGrid(columns: [
                GridItem(.fixed(100), spacing: 8),
                GridItem(.fixed(100), spacing: 8),
                GridItem(.fixed(100), spacing: 8),
            ]) {
                ForEach(0 ..< viewModel.items.count) { index in
                    
                    Button(action: {
                        viewModel.butFunc(index);
                    }, label: {
                        viewModel.items[index].padding().frame(width: 100, height: 100)
                    }).background(Color("White"))
                }
            }.background(Color("Black"))
        }.onChange(of: viewModel.crosses, { _, newValue in
            if newValue > 2 {
                if viewModel.checkForWinningCombination(grid: viewModel.items) { showAlert = true;
                }
            }
            if viewModel.checkForTie(items: viewModel.items) {showTieAlert = true}
        }).alert(viewModel.winningType == .cross ? "Crosses win" : "Circles win", isPresented: $showAlert, actions: {
            Button("Reset Game") {
                viewModel.resetGame()
            }
            Button("Ok"){
                
            }
        }) {
            Text("Congratulations!")
        }
            
        .alert("A draw", isPresented: $showTieAlert, actions: {
            Button("Reset Game") {
                viewModel.resetGame()
            }
            Button("Ok"){
                
            }
        }).onChange(of: viewModel.circles, { _, newValue in
            if newValue > 2 {
                if viewModel.checkForWinningCombination(grid: viewModel.items) { showAlert = true;}
                if viewModel.checkForTie(items: viewModel.items) {showTieAlert = true;}
            }
        })
        
.frame(width: 315, height: 315)
        Button(action: {viewModel.resetGame()}, label: {
            Text("Reset game").frame(width: 200, height: 50).background(.red).clipShape(RoundedRectangle(cornerRadius: 10)).foregroundStyle(.white).padding(50)
        })
        }
    }
}


#Preview {
    BoardView()
}
