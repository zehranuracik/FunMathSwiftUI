import SwiftUI

struct AdditionLessonView: View {
    var body: some View {
        let lessonTitle = "Toplama İşlemi Ders Kartları"
        let lessonImages = (1...5).map { "AdditionLessonCard\($0)" }

        return LessonDetailView(topicTitle: lessonTitle, topicImages: lessonImages, testView: AdditionLessonTestView(), imageName: "Background1")
            .background(Color("Color1").edgesIgnoringSafeArea(.all))
    }
}

struct AdditionLessonView_Previews: PreviewProvider {
    static var previews: some View {
        AdditionLessonView()
    }
}

