import SwiftUI

struct SubtractionLessonView: View {
    var body: some View {
        let lessonTitle = "Çıkarma İşlemi Ders Kartları"
        let lessonImages = (1...7).map { "SubtractionLessonCard\($0)" }

        return LessonDetailView(topicTitle: lessonTitle, topicImages: lessonImages, testView: SubtractionLessonTestView(), imageName: "Background4")
            .background(Color("Color1").edgesIgnoringSafeArea(.all))
    }
}

struct SubtractionLessonView_Previews: PreviewProvider {
    static var previews: some View {
        SubtractionLessonView()
    }
}

