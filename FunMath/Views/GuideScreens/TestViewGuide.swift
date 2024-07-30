import SwiftUI
struct TestViewGuide: View {
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
                        
                        Text("   - Toplama, Çıkarma, Çarpma ve Bölme dersleri ile alakalı sınava erişmek için ilgili bağlantılara tıklayın.")
                            .font(.body)
                        Text("   - Dersi seçtikten sonra süreli teste başlayabilirsiniz. Belirtilen süre içerisinde sorulara yanıt vermeniz gerekmektedir. Süre dolduğunda soru yanlış sayılacaktır.")
                            .font(.body)
                        
                        Text("• Karma Test İçeriği:")
                            .font(.headline)
                            .padding(.top, 10)
                            .padding(.bottom, 5)
                        
                        Text("   - Karma testi seçtikten sonra 4 işlemin karışık olarak bulunduğu teste başlayabilirsiniz.")
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
