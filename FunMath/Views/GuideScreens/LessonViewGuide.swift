import SwiftUI
struct LessonViewGuide: View {
    var body: some View {
        ZStack {
            Color("Color1").edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                Spacer()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("• Ders Seçenekleri:")
                            .font(.headline)
                            .padding(.bottom, 5)
                        
                        Text("   - Toplama, Çıkarma, Çarpma ve Bölme derslerine erişmek için ilgili bağlantılara tıklayın.")
                            .font(.body)
                        
                        Text("• Ders İçeriği:")
                            .font(.headline)
                            .padding(.top, 10)
                            .padding(.bottom, 5)
                        
                        Text("   - Her ders, ilgili matematiksel işlem hakkında temel bilgiler sunar.")
                            .font(.body)
                        
                        Text("   - Ders içeriğini gözden geçirdikten sonra, ilgili dersi seçerek pratik yapabilirsiniz.")
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
