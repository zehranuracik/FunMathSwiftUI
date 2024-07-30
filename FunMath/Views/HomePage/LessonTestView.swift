import SwiftUI
import Firebase

struct LessonTestView: View {
    @State private var userName: String = ""
    @State private var userID: String = ""
    @State private var showUserProfile = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("HomePageBackground")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 30) {
                    Spacer().frame(height: 60)
                    Text("Hoş Geldiniz")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color("ColorDarkBlue"))
                    
                    if !userName.isEmpty {
                        Text(userName)
                            .font(.headline)
                            .foregroundColor(Color("ColorDarkBlue"))
                            .padding(.bottom, 20)
                    }
                    
                    Image("Konu3")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200)
                        .padding(.horizontal)
                        .padding(.top, 30)
                        .padding(.bottom, 30)
                    
                    NavigationLink(destination: LessonView()) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 50)
                                .foregroundColor(Color("ColorOrange"))
                                .frame(width: 350, height: 70)
                            Text("Ders Öğren")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                    }
                    
                    NavigationLink(destination: TestView()) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 50)
                                .foregroundColor(Color("ColorPink"))
                                .frame(width: 350, height: 70)
                            Text("Test Ol")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                    }
                    
                    NavigationLink(destination: UserGuideView()) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 50)
                                .foregroundColor(Color("ColorDarkBlue"))
                                .frame(width: 350, height: 70)
                            Text("Kullanım Kılavuzu")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.bottom, 50)
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(trailing: Button(action: {
                    showUserProfile.toggle()
                }) {
                    Image(systemName: "person")
                        .font(.title2)
                        .foregroundColor(Color("Color3"))
                        .padding()
                        .background(.white)
                        .clipShape(Circle())
                        .padding()
                        .shadow(radius: 5)
                })
                .onAppear(perform: fetchUserData)
                
                NavigationLink(destination: UserProfileView(), isActive: $showUserProfile) {
                    EmptyView()
                }
            }
        }
    }
    
    func fetchUserData() {
        if let currentUser = Auth.auth().currentUser {
            userID = currentUser.uid // Kullanıcı ID'sini al
            
            let db = Firestore.firestore()
            let userRef = db.collection("users").document(userID)
            
            userRef.getDocument { document, error in
                if let document = document, document.exists {
                    if let data = document.data() {
                        userName = data["firstName"] as? String ?? "Kullanıcı"
                    }
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
}

struct LessonTestView_Previews: PreviewProvider {
    static var previews: some View {
        LessonTestView()
    }
}
