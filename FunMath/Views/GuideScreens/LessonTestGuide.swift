import SwiftUI
struct LessonTestGuide: View {
    var body: some View {
        ZStack {
            Color("Color1").edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                Spacer()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("• Sorular:")
                            .font(.headline)
                            .padding(.bottom, 5)
                        
                        Text("   - Soruları, altında bulunan kutuları uygun sıra ile seçerek cevaplayınız.")
                            .font(.body)
                        
                        Text("   - Doğru cevaplar için soru kartı yeşil olur ve ekranda konfeti patlar. Yanlış cevap için soru kartı kırmızı olur. Doğru ya da yanlış cevap verildikten sonra soru değişir.")
                            .font(.body)
                        
                        Text("• İlerleme Çubuğu:")
                            .font(.headline)
                            .padding(.top, 10)
                            .padding(.bottom, 5)
                        
                        Text("   - Ekranın üstünde bulunan ilerleme çubuğundan yanlış ve doğrularınızı, testin bitmesine kaç soru kaldığını görebilirsiniz.")
                            .font(.body)
                        
                        Text("   - İlerleme çubuğu, yanlış cevaplanan soru için kırmızı, doğru cevaplanan soru için yeşil olacaktır.")
                            .font(.body)
                        
                        Text("• Testi Bitir Butonu:")
                            .font(.headline)
                            .padding(.top, 10)
                            .padding(.bottom, 5)
                        
                        Text("   - Sorular bittikten sonra ekranda çıkan testi bitir butonuna tıklarsanız yanlış yaptığınız soruları görüntüleyebilirsiniz.")
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
