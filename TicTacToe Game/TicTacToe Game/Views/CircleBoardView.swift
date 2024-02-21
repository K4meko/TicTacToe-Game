import SwiftUI

struct CircleBoardView: View {
    @StateObject var controller = GameController()
    @StateObject var viewModel = OnlineGameObject();
    @State var showAlert = false;

        var body: some View {
            VStack{
                HStack{
                    Group{
                        Text("Game ID: ").bold()
                        Text("\(controller.gameId)")
                    }
                    
                    VStack{
                        Button(action: {
                          //  UIPasteboard.general.string = controller.gameId
                            // copy game id here
                        }, label: {
                            Image(systemName: "doc.on.clipboard").foregroundStyle(.blue)
                        })
                        Text("Copy")}.padding(.leading)
                }.padding()
                Spacer().frame(height: 100)
            ZStack {
                LazyVGrid(columns: [
                    GridItem(.fixed(100), spacing: 8),
                    GridItem(.fixed(100), spacing: 8),
                    GridItem(.fixed(100), spacing: 8),
                ]) {
                    ForEach(0 ..< 9) { index in
                        
                        Button(action: {
                            viewModel.items[index].changeState(newState: .circle);
                            viewModel.circles = viewModel.circles + 1
                        //    controller.makeMove(atIndex: index);
                        }, label: {
                            viewModel.items[index].padding().frame(width: 100, height: 100)
                        }).background(Color("White"))
                    }
                }.background(Color("Black"))
            }.onChange(of: viewModel.crosses, { _, newValue in
                
                
                    if viewModel.checkForWinningCombination(grid: viewModel.items) { showAlert = true;}
                
            }).alert(viewModel.winningType == .cross ? "Crosses win" : "Circles win", isPresented: $showAlert, actions: {
                Button("Reset Game") {
                    viewModel.resetGame()
                }
                Button("Ok"){
                    
                }
            }) {
                Text("Congratulations!")
            }.onChange(of: viewModel.circles, { _, newValue in
                    if viewModel.checkForWinningCombination(grid: viewModel.items) { showAlert = true;}
            })
            
    .frame(width: 315, height: 315)
            Button(action: {viewModel.resetGame()}, label: {
                Text("Reset game").frame(width: 200, height: 50).background(.red).clipShape(RoundedRectangle(cornerRadius:10)).foregroundStyle(.white).padding(50)
            })            }.onAppear(){
                // controller.startListeningForMoves()
            }
        }
    
}

#Preview {
    CircleBoardView()
}


