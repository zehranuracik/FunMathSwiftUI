import SwiftUI
import FirebaseFirestore

struct Mistake: Identifiable, Encodable {
    var id: String
    var questionID: String?
    var question: String
    var correctAnswer: String
    var userAnswer: String
}

class MistakeViewModel: ObservableObject {
    @Published var mistakes: [Mistake]

    init(mistakes: [Mistake] = []) {
        self.mistakes = mistakes
    }

    func addNewMistake(_ mistake: Mistake) {
        mistakes.append(mistake)
    }
}

struct MistakeView: View {
    @ObservedObject var viewModel: MistakeViewModel
    @State private var showingPrintAlert = false
    @State private var showPrintableView = false
    @State private var showUserGuide = false
    
    var body: some View {
        ZStack {
            Image("Background7")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Hatalı Cevaplar")
                    .font(.largeTitle)
                    .padding()
                
                TabView {
                    ForEach(viewModel.mistakes.indices, id: \.self) { index in
                        let mistake = viewModel.mistakes[index]
                        VStack {
                            Text("Soru \(index + 1)")
                                .font(.headline)
                                .padding(.bottom, 15)
                            
                            Text(mistake.question)
                                .font(.title)
                                .padding(.bottom, 10)
                            
                            VStack(alignment: .leading) {
                                Text("Kullanıcının Cevabı: \(mistake.userAnswer)")
                                    .font(.title2)
                                    .foregroundColor(.red)
                                    .padding(.bottom, 5)
                                
                                Text("Doğru Cevap: \(mistake.correctAnswer)")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding()
                        .frame(maxWidth: 400, maxHeight: .infinity)
                        .background(Color("Color2"))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding()
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                
                Spacer()
                
                Button(action: {
                    showingPrintAlert.toggle()
                }) {
                    Text("Rapor Oluştur ve Yazdır")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color("Color3"))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding()
                .alert(isPresented: $showingPrintAlert) {
                    Alert(title: Text("Yazdır"), message: Text("PDF olarak rapor oluşturmak istiyor musunuz?"), primaryButton: .default(Text("Evet")) {
                        showPrintableView = true
                    }, secondaryButton: .cancel(Text("Hayır")))
                }
                
                Spacer()
                
                NavigationLink(destination: PrintableView(viewModel: viewModel), isActive: $showPrintableView) {
                    EmptyView()
                }
                .hidden()

                NavigationLink(destination: LessonTestView()) {
                    Text("Ana Sayfaya Dön")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color("Color7"))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding()
                Spacer()
            }
            .padding()
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
                MistakeViewGuide()
            }
        }
        .navigationBarHidden(true)
    }
}

