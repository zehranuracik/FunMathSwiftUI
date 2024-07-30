import SwiftUI
struct MistakeViewGuide: View {
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
                        
                        Text("   - Ekrandaki kartları kaydırarak hatalı cevaplanan soruları, cevabınızı ve doğru cevabı görüntüleyebilirsiniz.")
                            .font(.body)
                        
                        Text("• Rapor Oluştur ve Yazdır Butonu:")
                            .font(.headline)
                            .padding(.top, 10)
                            .padding(.bottom, 5)
                        
                        Text("   - Rapor oluştur ve yazdır butonuna tıklayarak hatalı cevaplarınızın olduğu sorular ile bir rapor oluşturabilir, bu raporu istediğiniz platforma paylaşabilir, cihazınıza indirebilir yazdırabilirsiniz.")
                            .font(.body)
                        
                        Text("• Ana Sayfaya Dön Butonu:")
                            .font(.headline)
                            .padding(.top, 10)
                            .padding(.bottom, 5)
                        
                        Text("   - Ana sayfaya dön butonuna tıklayarak uygulama ana sayfasına dönebilirsiniz.")
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
