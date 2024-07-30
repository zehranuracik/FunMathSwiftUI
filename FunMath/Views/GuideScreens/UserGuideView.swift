import SwiftUI

struct UserGuideView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color("Color1").edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 10) {
                Spacer()
                
                Text("Uygulama Kullanım Kılavuzu")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                
                Group {
                    Text("• Ders Öğren Bölümü:")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("- 4 işlem (toplama, çıkarma, çarpma, bölme) için ayrı ayrı ders anlatımları bulunur.")
                        Text("- Ders anlatımlarına baktıktan sonra 'Testi Başlat' butonuna basarak dersle ilgili test olabilirsiniz.")
                        Text("- Testteki ilerlemeniz kayıt edilir.")
                        Text("- Test bittikten sonra yanlış yaptığınız soruların çıktısını yazdırabilirsiniz.")
                    }
                    
                    Text("• Test Ol Bölümü:")
                        .font(.headline)
                        .padding(.top, 10)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("- 4 işlem için süreli bir teste katılabilirsiniz.")
                        Text("- Karma test ol bölümünde 4 işlem sorularının da olduğu karma bir test olabilirsiniz.")
                        Text("- Belirtilen süre içerisinde soruları cevaplamanız gerekir.")
                        Text("- Cevaplamazsanız soru yanlış sayılır.")
                        Text("- Başarınızı görüntüleyebilir ve çıktısını yazdırabilirsiniz.")
                    }
                    Spacer()
                }
            }
            .padding()
            .background(Color("Color3").opacity(0.8)) // Kart arka planı
            .cornerRadius(15)
            .padding()
            .shadow(radius: 10)
            
        }
    }
}

struct UserGuideView_Previews: PreviewProvider {
    static var previews: some View {
        UserGuideView()
    }
}
