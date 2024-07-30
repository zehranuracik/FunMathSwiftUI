import SwiftUI

struct LessonDetailView<ContentView: View>: View {
    let topicTitle: String
    let topicImages: [String]
    let testView: ContentView // Test view'i
    let imageName : String
    
    @State private var isTestStarted = false // Test başlatıldı mı?
    @State private var showUserGuide = false
    
    var body: some View {
        ZStack {
            // Background Image
            Image(imageName)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                    
                TabView {
                    ForEach(topicImages, id: \.self) { imageName in
                        MathTopicView(imageName: imageName)
                            .padding() // Kart çevresine boşluk ekle
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always)) // Sayfa tab stilini kullan
                
                // Test başladıysa ilgili test view'e yönlendir
                NavigationLink(
                    destination: testView,
                    isActive: $isTestStarted
                ) {
                    EmptyView()
                }
                
                // Buton ekleyelim
                Button(action: {
                    self.isTestStarted = true
                }) {
                    Text("Pratik Yap")
                        .padding()
                        .font(.custom("", size: 20))
                        .foregroundColor(.white)
                        .frame(width: 200,height: 100)
                        .background(Color("Color7"))
                        .cornerRadius(50)
                }
                .padding()
            }
        }
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
            LessonCardGuide()
        }
    }
    
    struct MathTopicView: View {
        let imageName: String
        
        var body: some View {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 380, height: 750) // Increase the frame size
                .cornerRadius(10)
                .padding()
                .cornerRadius(15)
                .shadow(radius: 5)
                .padding()
        }
    }
}
