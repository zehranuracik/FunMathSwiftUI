import SwiftUI
import PDFKit

struct PrintableView: View {
    @ObservedObject var viewModel: MistakeViewModel
    @State private var showPDF = false
    @State private var pdfURL: URL?

    var body: some View {
        VStack {
            if let pdfURL = pdfURL, showPDF {
                PDFKitRepresentedView(url: pdfURL)
                    .edgesIgnoringSafeArea(.all)
            } else {
                Text("PDF Oluşturuluyor...")
                    .onAppear(perform: createPDF)
            }
        }
        .navigationBarTitle("PDF Önizleme", displayMode: .inline)
        .navigationBarItems(trailing: Button("Yazdır") {
            if let pdfURL = pdfURL {
                printPDF(url: pdfURL)
            }
        })
    }

    private func createPDF() {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let outputFileURL = documentDirectory.appendingPathComponent("Report.pdf")
        
        let pdfMetaData = [
            kCGPDFContextCreator: "FunMath",
            kCGPDFContextAuthor: "FunMath User"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageWidth = 8.5 * 72.0
        let pageHeight = 11.0 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        do {
            try renderer.writePDF(to: outputFileURL) { (context) in
                context.beginPage()
                
                let title = "Hatalı Sorular"
                let titleAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.boldSystemFont(ofSize: 18)
                ]
                let titleString = NSAttributedString(string: title, attributes: titleAttributes)
                titleString.draw(at: CGPoint(x: 20, y: 20))
                
                var currentY: CGFloat = 40
                let leftMargin: CGFloat = 20
                let topMargin: CGFloat = 20
                let questionSpacing: CGFloat = 20
                let sectionSpacing: CGFloat = 40
                let maxWidth = pageRect.width - 2 * leftMargin
                
                for (index, mistake) in viewModel.mistakes.enumerated() {
                    if currentY + sectionSpacing > pageRect.height {
                        context.beginPage()
                        currentY = topMargin
                    }
                    
                    let questionAttributes: [NSAttributedString.Key: Any] = [
                        .font: UIFont.systemFont(ofSize: 14),
                        .foregroundColor: UIColor.black
                    ]
                    let questionString = NSAttributedString(string: "Soru \(index + 1): \(mistake.question)", attributes: questionAttributes)
                    let questionStringHeight = questionString.boundingRect(with: CGSize(width: maxWidth, height: .greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil).height
                    questionString.draw(in: CGRect(x: leftMargin, y: currentY, width: maxWidth, height: questionStringHeight))
                    currentY += questionStringHeight + questionSpacing
                    
                    let userAnswerAttributes: [NSAttributedString.Key: Any] = [
                        .font: UIFont.systemFont(ofSize: 14),
                        .foregroundColor: UIColor.red
                    ]
                    let userAnswerString = NSAttributedString(string: "Kullanıcının Cevabı: \(mistake.userAnswer)", attributes: userAnswerAttributes)
                    let userAnswerStringHeight = userAnswerString.boundingRect(with: CGSize(width: maxWidth, height: .greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil).height
                    userAnswerString.draw(in: CGRect(x: leftMargin, y: currentY, width: maxWidth, height: userAnswerStringHeight))
                    currentY += userAnswerStringHeight + questionSpacing
                    
                    let correctAnswerAttributes: [NSAttributedString.Key: Any] = [
                        .font: UIFont.systemFont(ofSize: 14),
                        .foregroundColor: UIColor.blue
                    ]
                    let correctAnswerString = NSAttributedString(string: "Doğru Cevap: \(mistake.correctAnswer)", attributes: correctAnswerAttributes)
                    let correctAnswerStringHeight = correctAnswerString.boundingRect(with: CGSize(width: maxWidth, height: .greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil).height
                    correctAnswerString.draw(in: CGRect(x: leftMargin, y: currentY, width: maxWidth, height: correctAnswerStringHeight))
                    currentY += correctAnswerStringHeight + sectionSpacing
                }
            }
            
            self.pdfURL = outputFileURL
            self.showPDF = true
        } catch {
            print("Could not create PDF file: \(error.localizedDescription)")
        }
    }

    private func printPDF(url: URL) {
        let printController = UIPrintInteractionController.shared
        if UIPrintInteractionController.canPrint(url) {
            printController.printingItem = url
            printController.present(animated: true, completionHandler: nil)
        } else {
            print("Error: Cannot print PDF")
        }
    }
}

struct PDFKitRepresentedView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: url)
        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {}
}

struct PrintableView_Previews: PreviewProvider {
    static var previews: some View {
        PrintableView(viewModel: MistakeViewModel())
    }
}
