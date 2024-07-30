import SwiftUI

struct LessonView: View {
    @State private var showUserGuide = false
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.blue, .white, .pink]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .opacity(0.8)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 20) {
                
                HStack(spacing: 40) {
                    NavigationLink(destination: AdditionLessonView()) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundColor(Color("ColorOrange"))
                                .frame(maxWidth: .infinity, maxHeight: 150)
                                .clipShape(Circle())
                            Image("AdditionSymbol")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100) // Adjust the size as needed
                                
                        }
                    }

                    
                    NavigationLink(destination: SubtractionLessonView()) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundColor(Color("ColorDarkBlue"))
                                .frame(maxWidth: .infinity, maxHeight: 150)
                                .clipShape(Circle())
                            
                            Image("SubtractionSymbol")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100) // Adjust the size as needed
                        }
                    }
                }
                .padding(.bottom,40)
                
                Image("Konu2") // Replace "yourImageName" with your image asset name
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: 200)
                    .padding()
                
                HStack(spacing: 40) {
                    NavigationLink(destination: MultiplicationLessonView()) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundColor(Color("ColorDarkGreen"))
                                .frame(maxWidth: .infinity, maxHeight: 150)
                                .clipShape(Circle())
                            Image("MultiplicationSymbol")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100) // Adjust the size as needed
                        }
                    }
                    
                    NavigationLink(destination: DivisionLessonView()) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundColor(Color("ColorPink"))
                                .frame(maxWidth: .infinity, maxHeight: 150)
                                .clipShape(Circle())
                            Image("DivisionSymbol")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100) // Adjust the size as needed
                        }
                    }
                }
                .padding(.top,50)
                

            }
            .padding()
            .navigationBarTitle("Dersler", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                            showUserGuide.toggle()
                        }) {
                            Image(systemName: "questionmark.circle")
                                .font(.title2)
                                .foregroundColor(Color("Color3"))
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        })
            .sheet(isPresented: $showUserGuide) {
                LessonViewGuide()
            }
        }
    }
}


struct LessonView_Previews: PreviewProvider {
    static var previews: some View {
        LessonView()
    }
}
