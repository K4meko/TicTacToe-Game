import SwiftUI

struct PickView: View {
    @State var gameId:String = ""
    @State var ShowSignedView: Bool = false
    @State var ShowSignedViewJoin: Bool = false
    @State var showJoinView = false
    @State var showCircleBoard = false
    @State var showCrossBoard = false
    @EnvironmentObject var controller: GameController

    var body: some View {
        NavigationStack {
            ZStack { VStack {
                Ellipse().frame(width: 560, height: 400).foregroundStyle(.blue)
                Spacer().frame(height: 640)
                Ellipse().frame(width: 560, height: 400).foregroundStyle(.red)
            }
            VStack {
                Spacer().frame(height: 50)

                Text("Welcome to my \nTic-Tac-Toe Game!").padding(.horizontal).font(.largeTitle).fontWeight(.semibold)
                HStack { Text("Made by Kameko").font(.system(size: 17, weight: .semibold))
                    Spacer()
                }.padding(.leading, 140).foregroundStyle(Color(UIColor.gray))

                Spacer().frame(height: 120).multilineTextAlignment(.leading)
                NavigationLink(destination: BoardView(), label: { Text("Normal mode").frame(width: 220, height: 60).background(.red).foregroundColor(.white).clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))) })

                Spacer().frame(height: 40)
                
                Button(action: {
                    controller.createNewGame()
                    showCrossBoard = true
                    
                }, label: {
                    Text("Create an online game")
                        .frame(width: 220, height: 60)
                        .background(.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                })
                
                Button(action: {
                   showJoinView = true
                }, label: {
                    Text("Join an online game")
                        .frame(width: 220, height: 60)
                        .background(.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                })

            }.navigationDestination(isPresented: $showCrossBoard) {
                CrossBoardView()
            }
            .sheet(isPresented: $showJoinView, content: {GameJoinView(gameId: $gameId, show: $showJoinView, showCircleView: $showCircleBoard
            )
              
            })
            .navigationDestination(isPresented: $showCircleBoard) {
                CircleBoardView()
            }
                
            }
        }
    }
}

#Preview {
    PickView()
}
