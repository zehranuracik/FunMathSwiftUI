import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct QuizData {
    let questionTableName: String
    let errorTableName: String
    let successRateTableName: String
}

struct QuestionAnswerView: View {
    @State private var question: String = ""
    @State private var questionID: String = "" // Store the question ID
    @State private var correctAnswer: String = ""
    @State private var answers: [String] = []
    @State private var feedbacks: [String?] = Array(repeating: nil, count: 4)
    @State private var timer: Timer?
    @State private var timeRemaining: Int = 300
    @State private var isClickable: [Bool] = Array(repeating: true, count: 4)
    @State private var questionsAnswered: Int = 0
    @State private var isQuizOver: Bool = false
    @State private var showResults: Bool = false
    @State private var mistakes: [Mistake] = []
    @State private var currentQuizData: QuizData?
    @State private var correctAnswersCount: Int = 0
    @State private var successRate: Double = 0.0
    
    private var totalQuestion: Int = 5
    
    @StateObject private var mistakeViewModel = MistakeViewModel()
    
    let quizDataArray: [QuizData]
    
    init(quizDataArray: [QuizData]) {
        self.quizDataArray = quizDataArray
    }
    
    var body: some View {
        ZStack {
            Image("Background6")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            VStack {
                if isQuizOver {
                    VStack {
                        Text("Test bitti")
                            .font(.largeTitle)
                            .padding(.bottom, 30)
                        
                        Text("Doğru Sayısı: \(correctAnswersCount)")
                        Text("Başarı Yüzdesi: %\(String(format: "%.2f", successRate))")
                        
                        NavigationLink(destination: MistakeView(viewModel: mistakeViewModel), isActive: $showResults) {
                            Button(action: {
                                showResults = true
                            }) {
                                Text("Sonuçları Göster")
                                    .font(.headline)
                                    .padding()
                                    .background(Color("Color7"))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .onAppear {
                                        saveSuccessRateToFirestore(successRate: successRate, tableName: quizDataArray[0].successRateTableName)
                                    }
                } else {
                    if question.isEmpty {
                        Text("Yükleniyor...")
                            .onAppear {
                                fetchRandomQuestion()
                                startTimer()
                            }
                    } else {
                        Text("Soru: \(questionsAnswered + 1) / \(totalQuestion)")
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        CardView {
                            VStack {
                                Text(question)
                                    .font(.title)
                                    .padding(.top,30)
                                Spacer()
                                CircularTimerView(timeRemaining: $timeRemaining)
                                    .frame(width: 100, height: 100)
                                    .padding(.bottom)
                            }
                        }
                        .background(Color("Color6")) // Change the background color of the card
                        .cornerRadius(30)
                        .padding()
                        
                        Spacer()
                        
                        VStack(spacing: 20) {
                            ForEach(0..<answers.count / 2, id: \.self) { index in
                                HStack(spacing: 20) {
                                    ForEach(0..<2, id: \.self) { column in
                                        let answerIndex = index * 2 + column
                                        if answerIndex < answers.count {
                                            AnswerButton(answer: answers[answerIndex], isCorrect: answers[answerIndex] == correctAnswer, feedback: feedbacks[answerIndex], isClickable: isClickable[answerIndex]) { selectedAnswer in
                                                if selectedAnswer == correctAnswer {
                                                    feedbacks[answerIndex] = "Doğru!"
                                                    correctAnswersCount += 1
                                                } else {
                                                    feedbacks[answerIndex] = "Yanlış! Doğru cevap: \(correctAnswer)"
                                                    // Save the mistake
                                                    if let quizData = currentQuizData {
                                                        let mistake = Mistake(id: UUID().uuidString, questionID: questionID, question: question, correctAnswer: correctAnswer, userAnswer: selectedAnswer)
                                                        mistakes.append(mistake)
                                                        mistakeViewModel.addNewMistake(mistake)
                                                        saveMistakeToFirestore(mistake, errorTableName: quizData.errorTableName)
                                                    }
                                                }
                                                stopTimer()
                                                fetchNextQuestionAfterDelay()
                                                isClickable = Array(repeating: false, count: 4)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                        
                        Spacer()
                    }
                }
            }
            .padding(.top,60)
            .padding(.bottom,60)
        }
            .onAppear {
                fetchRandomQuestion()
            }
        }
    
    func fetchRandomQuestion() {
        let db = Firestore.firestore()
        if let quizData = quizDataArray.randomElement() {
            self.currentQuizData = quizData
            let questionsRef = db.collection(quizData.questionTableName)
            
            questionsRef.getDocuments { (snapshot, error) in
                if let error = error {
                    print("Sorular yüklenirken bir hata oluştu: \(error)")
                } else if let snapshot = snapshot {
                    let documents = snapshot.documents
                    if let document = documents.randomElement() {
                        let data = document.data()
                        self.questionID = document.documentID // Store the question ID
                        self.question = data["question"] as? String ?? ""
                        self.correctAnswer = data["correctAnswer"] as? String ?? ""
                        if let wrongAnswers = data["wrongAnswers"] as? [String] {
                            var allAnswers = wrongAnswers + [self.correctAnswer]
                            allAnswers.shuffle() // Shuffle the answers
                            self.answers = allAnswers
                            self.feedbacks = Array(repeating: nil, count: allAnswers.count)
                            self.isClickable = Array(repeating: true, count: allAnswers.count)
                        }
                    }
                }
            }
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if timeRemaining > 0 {
                withAnimation(.linear(duration: 1.0)) {
                    timeRemaining -= 1
                }
            } else {
                stopTimer()
                // Show the correct answer when time runs out and load the next question after a delay
                for (index, answer) in answers.enumerated() {
                    if answer == correctAnswer {
                        feedbacks[index] = "Doğru!"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            fetchNextQuestionAfterDelay()
                        }
                    }
                }
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        timeRemaining = 300
        
        // Check if the user hasn't answered the question
        if feedbacks.allSatisfy({ $0 == nil }) {
            // Save the question as a mistake
            if let quizData = currentQuizData {
                let mistake = Mistake(id: UUID().uuidString, questionID: questionID, question: question, correctAnswer: correctAnswer, userAnswer: "No answer")
                mistakes.append(mistake)
                mistakeViewModel.addNewMistake(mistake)
                saveMistakeToFirestore(mistake, errorTableName: quizData.errorTableName)
            }
            
            if self.questionsAnswered >= self.totalQuestion {
                self.isQuizOver = true
                // Calculate success rate
                if self.totalQuestion > 0 {
                    self.successRate = Double(self.correctAnswersCount) / Double(self.totalQuestion) * 100.0
                }
            }
        }
    }
    
    func fetchNextQuestionAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.questionsAnswered += 1
            
            if self.questionsAnswered >= self.totalQuestion {
                self.isQuizOver = true
                // Calculate success rate
                if self.totalQuestion > 0 {
                    self.successRate = Double(self.correctAnswersCount) / Double(self.totalQuestion) * 100.0
                }
            } else {
                self.fetchRandomQuestion()
                self.startTimer()
            }
        }
    }
    
    func saveMistakeToFirestore(_ mistake: Mistake, errorTableName: String) {
        guard let user = Auth.auth().currentUser else {
            print("No authenticated user.")
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.uid)
        let mistakesRef = userRef.collection(errorTableName)
        
        do {
            let jsonData = try JSONEncoder().encode(mistake) // Convert Mistake to JSON data
            guard let data = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                print("Failed to convert Mistake to dictionary.")
                return
            }
            try mistakesRef.document(mistake.id).setData(data) // Set data to Firestore
        } catch let error {
            print("Error writing mistake to Firestore: \(error)")
        }
        
    }
    
    func saveSuccessRateToFirestore(successRate: Double, tableName: String) {
        guard let user = Auth.auth().currentUser else {
            print("No authenticated user.")
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.uid)
        let successRateRef = userRef.collection(tableName)
        
        let successRateData: [String: Any] = ["successRate": successRate]
        
        // Check if there's an existing document in the collection
        successRateRef.getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching documents: \(error)")
            } else {
                if let document = snapshot?.documents.first {
                    // If document exists, update its data
                    document.reference.updateData(successRateData) { error in
                        if let error = error {
                            print("Error updating document: \(error)")
                        } else {
                            print("Success rate updated successfully.")
                        }
                    }
                } else {
                    // If document doesn't exist, create a new one
                    successRateRef.addDocument(data: successRateData) { error in
                        if let error = error {
                            print("Error adding document: \(error)")
                        } else {
                            print("Success rate saved to Firestore.")
                        }
                    }
                }
            }
        }
    }

    
    
    struct CardView<Content: View>: View {
        let content: Content
        
        init(@ViewBuilder content: () -> Content) {
            self.content = content()
        }
        
        var body: some View {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.clear) // Keep the fill color clear to use the overlay color
                .shadow(radius: 50)
                .overlay(
                    content
                )
                .padding()
        }
    }
    
    struct CircularTimerView: View {
        @Binding var timeRemaining: Int
        
        var body: some View {
            ZStack {
                Circle()
                    .trim(from: 0.0, to: CGFloat(timeRemaining) / 10.0)
                    .stroke(timeRemaining > 10 ? Color.green : (timeRemaining > 5 ? Color.orange : Color.red), lineWidth: 8)
                    .rotationEffect(Angle(degrees: -90))
                    .animation(.linear(duration: 1), value: timeRemaining)
                    .frame(width: 100, height: 100)
                Text("\(timeRemaining)")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(timeRemaining > 3 ? Color.green : (timeRemaining > 1 ? Color.orange : Color.red))
                    .animation(nil) // Disable animation for the text
            }
        }
    }
    
    struct AnswerButton: View {
        var answer: String
        var isCorrect: Bool
        var feedback: String?
        var isClickable: Bool
        var action: (String) -> Void
        
        var body: some View {
            Button(action: {
                if isClickable {
                    action(answer)
                }
            }) {
                Text(answer)
                    .font(.headline)
                    .padding()
                    .frame(width: 170, height: 70)
                    .background(feedback == nil ? Color("Color7") : (isCorrect ? Color.green : Color.red))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 2)
                    )
                    .disabled(!isClickable) // Disable based on clickability
            }
            .aspectRatio(1, contentMode: .fit) // Make the buttons square
        }
    }
}
