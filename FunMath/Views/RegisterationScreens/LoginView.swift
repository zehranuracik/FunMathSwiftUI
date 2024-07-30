import SwiftUI
import Firebase

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoggedIn = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isAdmin = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("LoginBackground")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Giriş Yap")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top,80)
                        
                    Spacer()
                    Group {
                        CustomTextField(placeholder: "Email", text: $email, keyboardType: .emailAddress)
                            .autocapitalization(.none)
                        
                        CustomSecureField(placeholder: "Password", text: $password)
                    }
                    .padding()
                    Spacer()
                    
                    NavigationLink(destination: isAdmin ? AnyView(AddQuestionView()) : AnyView(LessonTestView()), isActive: $isLoggedIn) {
                        EmptyView()
                    }
                    
                    Button(action: {
                        loginUser(email: email, password: password)
                    }) {
                        Text("Login")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("Color7"))
                            .cornerRadius(10)
                            .padding(.horizontal, 20) // TextField ve SecureField ile aynı yatay boşluk
                    }
                    .padding(.top, 20)
                    Spacer()
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Login Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
        }
    }
    
    enum FirebaseAuthError: Error {
        case userNotFound
        case wrongPassword
        case unknownError(String)
        
        init(_ errorCode: Int) {
            switch errorCode {
            case AuthErrorCode.userNotFound.rawValue:
                self = .userNotFound
            case AuthErrorCode.wrongPassword.rawValue:
                self = .wrongPassword
            default:
                self = .unknownError("Bilinmeyen bir hata oluştu.")
            }
        }
    }

    func loginUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error as NSError? {
                switch error.code {
                case AuthErrorCode.wrongPassword.rawValue:
                    self.alertMessage = "Şifre hatalı."
                case AuthErrorCode.invalidEmail.rawValue:
                    self.alertMessage = "Geçersiz email."
                case AuthErrorCode.accountExistsWithDifferentCredential.rawValue:
                    self.alertMessage = "Farklı bir kimlik bilgisiyle hesap mevcut."
                default:
                    self.alertMessage = "Bilinmeyen bir hata oluştu: \(error.localizedDescription)"
                }
                self.showAlert = true
            } else {
                if let user = authResult?.user {
                    // Admin kontrolü
                    if user.email == "admin@admin.com" {
                        self.isAdmin = true
                    }
                    // Kullanıcı giriş yaptığında isLoggedIn değişkenini true olarak ayarla
                    self.isLoggedIn = true
                } else {
                    self.alertMessage = "Oturum açılamadı."
                    self.showAlert = true
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
