import SwiftUI

struct SubtractionQuizView: View {
    let questionTableName: String = "çıkartma_questions"
        let errorTableName: String = "subtraction_quiz_mistake"
    var body: some View {
        let quizDataArray = [
            QuizData(questionTableName: questionTableName, errorTableName: errorTableName,successRateTableName: "subtraction_quiz_succes_rate"),
        ]
        
        return QuestionAnswerView(quizDataArray: quizDataArray)
    }
}

struct SubtractionQuizView_Previews: PreviewProvider {
    static var previews: some View {
        SubtractionQuizView()
    }
}
