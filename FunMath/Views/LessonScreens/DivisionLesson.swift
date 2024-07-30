import SwiftUI

struct DivisionLessonView: View {
    var body: some View {
        let lessonTitle = "Bölme İşlemi Ders Kartları"
        let lessonImages = (1...7).map { "DivisionLessonCard\($0)" }

        return LessonDetailView(topicTitle: lessonTitle, topicImages: lessonImages, testView: DivisionLessonTestView(), imageName: "Background2")
            .background(Color("Color1").edgesIgnoringSafeArea(.all))
    }
}

struct DivisionLessonView_Previews: PreviewProvider {
    static var previews: some View {
        DivisionLessonView()
    }
}
