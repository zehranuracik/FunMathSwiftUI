import SwiftUI

struct MultiplicationLessonView: View {
    var body: some View {
        let lessonTitle = "Çarpma İşlemi Ders Kartları"
        let lessonImages = (1...7).map { "MultipliationLessonCard\($0)" }

        return LessonDetailView(topicTitle: lessonTitle, topicImages: lessonImages, testView: MultiplicationLessonTestView(), imageName: "Background3")
            .background(Color("Color1").edgesIgnoringSafeArea(.all))
    }
}

struct MultiplicationLessonView_Previews: PreviewProvider {
    static var previews: some View {
        MultiplicationLessonView()
    }
}

