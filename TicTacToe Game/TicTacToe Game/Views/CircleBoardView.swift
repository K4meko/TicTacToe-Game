import SwiftUI

struct CircleBoardView: View {
    @EnvironmentObject var controller: GameController
    @State var showAlert = false;
    
    var body: some View {
        VStack{
//            HStack{
//                Group{
//                    Text("Game ID: ").bold()
//                    Text("\(controller.gameId)")
//                }
//                
//                                    VStack{
//                                        Button(action: {
//                                          //  UIPasteboard.general.string = controller.gameId
//                                            // copy game id here
//                                        }, label: {
//                                            Image(systemName: "doc.on.clipboard").foregroundStyle(.blue)
//                                        })
//                                        Text("Copy")}.padding(.leading)
//                                }.padding()
//                Spacer().frame(height: 100)
                ZStack {
                    LazyVGrid(columns: [
                        GridItem(.fixed(100), spacing: 8),
                        GridItem(.fixed(100), spacing: 8),
                        GridItem(.fixed(100), spacing: 8),
                    ]) {
                        ForEach(0 ..< 9) { index in
                            
                        Button(action: { if (controller.isCross == false) {
                               
                                controller.makeMove(atIndex: index);
                            }
                            else{
                                return
                            }
                            }, label: {
                                controller.items[index].padding().frame(width: 100, height: 100)
                            }).background(Color("White"))
                        }
                    }.background(Color("Black"))
                }.onChange(of: controller.crosses, { _, newValue in
                    
                    
                    if controller.checkForWinningCombination(grid: controller.items) { showAlert = true;}
                    
                }).alert(controller.winningType == .cross ? "Crosses win" : "Circles win", isPresented: $controller.isWon, actions: {
                    Button("Reset Game") {
                        controller.resetGame()
                        
                    }
                    Button("Ok"){
                        
                    }
                }) {
                    Text("Congratulations!")
                }.onChange(of: controller.circles, { _, newValue in
                    if controller.checkForWinningCombination(grid: controller.items) { showAlert = true;}

                })
                
                .frame(width: 315, height: 315)
                Button(action: {controller.resetGame()}, label: {
                    Text("Reset game").frame(width: 200, height: 50).background(.red).clipShape(RoundedRectangle(cornerRadius:10)).foregroundStyle(.white).padding(50)
                })            }.onAppear(){
                    // controller.startListeningForMoves()
                }
        }
        
    }

#Preview {
    CircleBoardView()
}


