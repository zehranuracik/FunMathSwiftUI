import SwiftUI
import FirebaseFirestore

struct AddQuestionView: View {
    @State private var questionText: String = ""
    @State private var correctAnswer: String = ""
    @State private var wrongAnswers: [String] = ["", "", ""]
    @State private var selectedQuestionType: QuestionType = .addition // Başlangıçta toplama sorusu seçili
    
    enum QuestionType: String, CaseIterable {
        case addition = "Toplama"
        case subtraction = "Çıkartma"
        case multiplication = "Çarpma"
        case division = "Bölme"
    }
    
    var body: some View {
        VStack {
            Picker(selection: $selectedQuestionType, label: Text("Soru Türü")) {
                ForEach(QuestionType.allCases, id: \.self) { type in
                    Text(type.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            TextField("Soru metni", text: $questionText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Doğru cevap", text: $correctAnswer)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            ForEach(0..<3, id: \.self) { index in
                TextField("Yanlış cevap \(index + 1)", text: $wrongAnswers[index])
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            
            Button("Soruyu Kaydet") {
                saveQuestion()
            }
            .padding()
            
            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
    
    func saveQuestion() {
        // Firestore'a soruyu kaydet
        let db = Firestore.firestore()
        let questionsRef = db.collection(selectedQuestionType.rawValue.lowercased() + "_questions2") // Koleksiyon adını seçilen soru türüne göre oluştur
        
        let data: [String: Any] = [
            "question": questionText,
            "correctAnswer": correctAnswer,
            "wrongAnswers": wrongAnswers
        ]
        
        questionsRef.addDocument(data: data) { error in
            if let error = error {
                print("Soru kaydedilirken bir hata oluştu: \(error)")
            } else {
                print("Soru başarıyla kaydedildi.")
                // Kaydedildikten sonra alanları sıfırla
                questionText = ""
                correctAnswer = ""
                wrongAnswers = ["", "", ""]
            }
        }
    }
}

struct AddQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        AddQuestionView()
    }
}
