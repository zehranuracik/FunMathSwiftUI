import SwiftUI

struct MixedQuizView: View {
    var body: some View {
        let quizDataArray = [
            QuizData(questionTableName: "toplama_questions", errorTableName: "addition_quiz_mistake",successRateTableName: "addition_quiz_succes_rate"),
            QuizData(questionTableName: "çıkartma_questions", errorTableName: "subtraction_quiz_mistake",successRateTableName: "subtraction_quiz_succes_rate"),
            QuizData(questionTableName: "çarpma_questions", errorTableName: "multiplication_quiz_mistake",successRateTableName: "multiplication_quiz_succes_rate"),
            QuizData(questionTableName: "bölme_questions", errorTableName: "division_quiz_mistake",successRateTableName: "division_quiz_succes_rate")
        ]
        
        return QuestionAnswerView(quizDataArray: quizDataArray)
    }
}

struct MixedQuizView_Previews: PreviewProvider {
    static var previews: some View {
        MixedQuizView()
    }
}
