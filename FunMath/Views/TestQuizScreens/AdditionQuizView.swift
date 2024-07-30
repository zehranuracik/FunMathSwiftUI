import SwiftUI

struct AdditionQuizView: View {
    var body: some View {
        let quizDataArray = [
            QuizData(questionTableName: "toplama_questions", errorTableName: "addition_quiz_mistake",successRateTableName: "addition_quiz_succes_rate"),
        ]
        
        return QuestionAnswerView(quizDataArray: quizDataArray)
    }
}

struct AdditionQuizView_Previews: PreviewProvider {
    static var previews: some View {
        AdditionQuizView()
    }
}
