import SwiftUI

struct DivisionQuizView: View {
    var body: some View {
        let quizDataArray = [
            QuizData(questionTableName: "bölme_questions", errorTableName: "division_quiz_mistake",successRateTableName: "division_quiz_succes_rate" )
        ]
        return QuestionAnswerView(quizDataArray: quizDataArray)
    }
}

struct DivisionQuizView_Previews: PreviewProvider {
    static var previews: some View {
       DivisionQuizView()
    }
}
