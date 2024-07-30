import SwiftUI
import Firebase

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Image("Konu6")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .padding(.top,150)
                    .padding(.bottom,-150)
                
                Image("Konu")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 400, height: 400)
                
                NavigationLink(destination: RegisterView()) {
                    Text("Kayıt Ol")
                        .font(.custom("String", size: 25))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .frame(height: 80)
                        .background(Color("Color3"))
                        .cornerRadius(50)
                        .padding(.horizontal,50)
                        .padding(.top,50)
                        .padding(.bottom,30)
                }
                
                NavigationLink(destination: LoginView()) {
                    Text("Giriş Yap")
                        .font(.custom("String", size: 25))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .frame(height: 80)
                        .background(Color("Color7"))
                        .cornerRadius(50)
                        .padding(.horizontal, 50)
                        .padding(.bottom,150)
                }
                
                Spacer()
                Spacer()
            }
            .background(RainbowGradientView())
            .edgesIgnoringSafeArea(.all)
            .navigationBarBackButtonHidden()
        }
    }
}

struct RainbowGradientView: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 1.0, green: 0.6, blue: 0.6), // Vibrant pastel red
                Color(red: 1.0, green: 0.7, blue: 0.4), // Vibrant pastel orange
                Color(red: 1.0, green: 1.0, blue: 0.5), // Vibrant pastel yellow
                Color(red: 0.6, green: 1.0, blue: 0.6), // Vibrant pastel green
                Color(red: 0.6, green: 0.7, blue: 1.0), // Vibrant pastel blue
                Color(red: 0.7, green: 0.6, blue: 1.0), // Vibrant pastel indigo
                Color(red: 1.0, green: 0.6, blue: 1.0)  // Vibrant pastel purple
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .edgesIgnoringSafeArea(.all) // Makes the gradient cover the entire screen
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
