import SwiftUI
import UIKit

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Your App Name")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            Spacer()
            
            NavigationLink(destination: Text("Register View")) {
                Text("Kayıt Ol")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            
            NavigationLink(destination: Text("Login View")) {
                Text("Giriş Yap")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class MainViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contentView = UIHostingController(rootView: ContentView())
        addChild(contentView)
        view.addSubview(contentView.view)
        contentView.didMove(toParent: self)
    }
}
