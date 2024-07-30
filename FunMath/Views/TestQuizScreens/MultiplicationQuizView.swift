import SwiftUI

struct MultiplicationQuizView: View {
    var body: some View {
        let quizDataArray = [
            QuizData(questionTableName: "çarpma_questions", errorTableName: "multiplication_quiz_mistake",successRateTableName: "multiplication_quiz_succes_rate"),
        ]
        return QuestionAnswerView(quizDataArray: quizDataArray)
    }
}

struct MultiplicationQuizView_Previews: PreviewProvider {
    static var previews: some View {
        MultiplicationQuizView()
    }
}
