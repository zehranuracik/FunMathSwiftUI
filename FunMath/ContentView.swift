import SwiftUI

struct QuizView: View {
    @State private var selectedAnswer: String? = nil
    @State private var showAlert = false

    let question = "SwiftUI hangi yılda tanıtıldı?"
    let answers = ["2018", "2019", "2020", "2021"]
    let correctAnswer = "2019"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(question)
                .font(.title)
                .fontWeight(.bold)
            
            ForEach(answers, id: \.self) { answer in
                Button(action: {
                    selectedAnswer = answer
                    showAlert = true
                }) {
                    Text(answer)
                        .padding()
                        .background(Color.blue.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text(selectedAnswer == correctAnswer ? "Doğru!" : "Yanlış!"),
                        message: Text(selectedAnswer == correctAnswer ? "Tebrikler, doğru cevabı buldunuz!" : "Maalesef, doğru cevap \(correctAnswer)."),
                        dismissButton: .default(Text("Tamam"))
                    )
                }
            }
        }
        .padding()
    }
}

struct ContentView: View {
    var body: some View {
        QuizView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
