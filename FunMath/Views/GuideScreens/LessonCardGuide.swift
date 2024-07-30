import SwiftUI
struct LessonCardGuide: View {
    var body: some View {
        ZStack {
            Color("Color1").edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                Spacer()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("• Kartlar:")
                            .font(.headline)
                            .padding(.bottom, 5)
                        
                        Text("   - Kartları sağa kaydırarak ders ile ilgili görsellere ulaşabilirsiniz.")
                            .font(.body)
                        
                        Text("• Pratik Yap Butonu :")
                            .font(.headline)
                            .padding(.top, 10)
                            .padding(.bottom, 5)
                        
                        Text("   - Ders içeriğini gözden geçirdikten sonra, pratik yap butonuna tıklayarak pratik yapabilirsiniz.")
                            .font(.body)
                    }
                    .padding()
                    .background(Color("Color3"))
                    .cornerRadius(15)
                    .padding()
                    .shadow(radius: 10)
                }
                .padding(.top,50)
                
                Spacer()
                
            }
            .padding(.top, 40)
        }
    }
}
