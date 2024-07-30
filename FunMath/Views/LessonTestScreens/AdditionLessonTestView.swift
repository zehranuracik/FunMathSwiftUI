import SwiftUI
import ConfettiSwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct AdditionLessonTestView: View {
    @State private var firstNumber: Int = Int.random(in: 10...999)
    @State private var secondNumber: Int = Int.random(in: 10...99)
    @State private var answer: String = ""
    @State private var options: [String] = []
    @State private var counter: Int = 0
    @State private var selectedOptionIndices: [Int] = []
    @State private var isWrongAnswer: Bool = false
    @State private var cardColor: Color = Color("Color6")
    @State private var testCounter: Int = 0
    @State private var totalTests: Int = 5
    @State private var totaloptions: Int = 0
    @State private var showFinishButton: Bool = false
    @State private var userId: String? = nil
    @State private var progressArray: [Bool] = []
    @State private var showUserGuide = false


    @StateObject private var mistakeViewModel = MistakeViewModel()

    private var correctAnswer: String {
        return String(firstNumber + secondNumber)
    }

    var body: some View {
        ZStack {
            Image("Background5")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // Özel ilerleme çubuğu
                HStack(spacing: 4) {
                    ForEach(0..<totalTests, id: \.self) { index in
                        Rectangle()
                            .fill(index < progressArray.count ? (progressArray[index] ? Color("ColorGreen") : Color("ColorRed")) : Color.gray)
                            .frame(height: 10)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                Spacer()
                
                if testCounter < totalTests {
                    RoundedRectangle(cornerRadius: 50)
                        .fill(cardColor)
                        .frame(height: 200)
                        .overlay(
                            VStack {
                                Text("\(firstNumber) + \(secondNumber)")
                                    .font(.largeTitle)
                                    .padding()
                            }
                        )
                        .padding(50)

                    HStack {
                        ForEach(answer.map { String($0) }, id: \.self) { char in
                            Text(char)
                                .font(.largeTitle)
                                .padding()
                                .frame(width: 70, height: 70)
                                .background(Color("Color7").opacity(0.2))
                                .cornerRadius(10)
                                .transition(.slide)
                        }
                    }
                    .animation(.default, value: answer)
                    .frame(height: 50)
                    

                    HStack(spacing: 20) {
                        ForEach(options.indices, id: \.self) { index in
                            let isSelected = self.selectedOptionIndices.contains(index)
                            if !isSelected {
                                Button(action: {
                                    withAnimation {
                                        self.moveOptionToAnswer(index)
                                    }
                                }) {
                                    Text(self.options[index])
                                        .font(.title)
                                        .padding()
                                        .frame(width: 70, height: 70)
                                        .background(Color("Color7"))
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                                .transition(.slide)
                            }
                        }
                    }
                    .animation(.default)
                } else if showFinishButton {
                    if let userId = userId {
                        NavigationLink(destination: MistakeView(viewModel: mistakeViewModel)) {
                            Text("Testi Bitir")
                                .font(.title)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
                
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
                LessonTestGuide()
            }

            ConfettiCannon(counter: $counter)
        }
        .onAppear {
            setOptions()
            fetchUserId()
        }
    }

    private func setOptions() {
        let shuffledCorrectAnswer = correctAnswer.shuffled()
        options = shuffledCorrectAnswer.map { String($0) }
    }

    private func moveOptionToAnswer(_ index: Int) {
        let selectedOption = options[index]
        answer += selectedOption
        selectedOptionIndices.append(index)
        totaloptions += 1
        if totaloptions == options.count {
            checkAnswer()
            totaloptions = 0
        }
    }

    private func checkAnswer() {
        if answer == correctAnswer {
            counter += 1
            cardColor = Color("ColorGreen")
            progressArray.append(true)
        } else {
            isWrongAnswer = true
            cardColor = Color("ColorRed")
            progressArray.append(false)
            if let userId = userId {
                let mistake = Mistake(id: UUID().uuidString, question: "\(firstNumber) + \(secondNumber)", correctAnswer: correctAnswer, userAnswer: answer)
                saveMistake(userId: userId, mistake: mistake)
                mistakeViewModel.addNewMistake(mistake)
            }
        }

        testCounter += 1
        if testCounter == totalTests {
            showFinishButton = true
            print(showFinishButton)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.resetGame()
            if testCounter < totalTests {
                self.firstNumber = Int.random(in: 10...999)
                self.secondNumber = Int.random(in: 10...99)
                self.setOptions()
                self.cardColor = Color("Color6")
            }
        }
    }

    private func saveMistake(userId: String, mistake: Mistake) {
        let db = Firestore.firestore()
        db.collection("users").document(userId).collection("mistakes").document(mistake.id).setData([
            "question": mistake.question,
            "correctAnswer": mistake.correctAnswer,
            "userAnswer": mistake.userAnswer
        ]) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added")
            }
        }
    }

    private func resetGame() {
        answer = ""
        selectedOptionIndices = []
        isWrongAnswer = false
    }

    private func fetchUserId() {
        if let currentUser = Auth.auth().currentUser {
            userId = currentUser.uid // Kullanıcı ID'sini al
        }
    }
}

struct AdditionLessonTestView_Previews: PreviewProvider {
    static var previews: some View {
        AdditionLessonTestView()
    }
}
