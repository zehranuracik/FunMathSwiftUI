import SwiftUI
import Firebase
import FirebaseFirestore

struct RegisterView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var birthDate = Date()
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Image("RegisterBackground")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Kayıt Ol")
                    .font(.title)
                    .padding()
                Spacer()
                Group {
                    CustomTextField(placeholder: "İsim", text: $firstName)
                    CustomTextField(placeholder: "Soyisim", text: $lastName)
                    DatePicker("Doğum Tarihi", selection: $birthDate, in: ...Date(), displayedComponents: .date)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                    
                    CustomTextField(placeholder: "E-posta", text: $email, keyboardType: .emailAddress)
                    CustomSecureField(placeholder: "Parola", text: $password)
                    CustomSecureField(placeholder: "Parolayı Onayla", text: $confirmPassword)
                }
                .padding()
                
                Spacer()
                
                Button(action: signUp) {
                    Text("Kayıt Ol")
                        .padding()
                        .frame(maxWidth: 350)
                        .foregroundColor(.white)
                        .background(Color.blue) // Buton rengi
                        .cornerRadius(10)
                        .padding(.trailing, 0) // Butonun sağa doğru kaymasını sağlar
                }
                .padding(.bottom, 20) // Butonun alt boşluğunu artırır
            }
            .padding(.top, 60)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Hata"), message: Text(alertMessage), dismissButton: .default(Text("Tamam")))
        }
    }
    
    func signUp() {
        if firstName.isEmpty || lastName.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            showAlert = true
            alertMessage = "Tüm alanları doldurun."
            return
        }
        
        if password != confirmPassword {
            showAlert = true
            alertMessage = "Parolalar eşleşmiyor."
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                showAlert = true
                alertMessage = error.localizedDescription
            } else {
                // Firebase Firestore'a kullanıcı bilgilerini kaydet
                let db = Firestore.firestore()
                let userData: [String: Any] = [
                    "firstName": firstName,
                    "lastName": lastName,
                    "birthDate": birthDate,
                    "email": email
                ]
                db.collection("users").document(authResult!.user.uid).setData(userData) { error in
                    if let error = error {
                        print("Error adding document: \(error)")
                    } else {
                        print("Document added with ID: \(authResult!.user.uid)")
                        // Kayıt başarılı, LoginView'a yönlendir
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(Color.white.opacity(0.8))
            .cornerRadius(10)
            .padding(.horizontal, 20)
            .keyboardType(keyboardType)
    }
}

struct CustomSecureField: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        SecureField(placeholder, text: $text)
            .padding()
            .background(Color.white.opacity(0.8))
            .cornerRadius(10)
            .padding(.horizontal, 20)
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RegisterView()
                .navigationBarTitle("")
                .navigationBarHidden(true)
        }
    }
}
