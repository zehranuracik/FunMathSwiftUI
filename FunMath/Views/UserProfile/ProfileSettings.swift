import SwiftUI
import Firebase
import FirebaseFirestore

struct ProfileSettingsView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var birthDate = Date()
    @State private var email = ""
    @State private var password = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Image("RegisterBackground")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            ScrollView{
                VStack {
                    Text("Profil Ayarları")
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
                        
                        TextField("E-posta", text: $email)
                            .padding()
                            .background(Color.gray.opacity(0.4))
                            .cornerRadius(10)
                            .padding(.horizontal, 20)
                            .disabled(true)
                        
                        CustomSecureField(placeholder: "Mevcut Parola", text: $password)
                        CustomSecureField(placeholder: "Yeni Parola", text: $newPassword)
                        CustomSecureField(placeholder: "Yeni Parolayı Onayla", text: $confirmPassword)
                    }
                    .padding()
                    
                    Spacer()
                    
                    Button(action: updateProfile) {
                        Text("Güncelle")
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
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Mesaj"), message: Text(alertMessage), dismissButton: .default(Text("Tamam")))
        }
        .onAppear {
            loadUserProfile()
        }
    }
    
    func loadUserProfile() {
        if let currentUser = Auth.auth().currentUser {
            let userID = currentUser.uid
            let db = Firestore.firestore()
            let docRef = db.collection("users").document(userID)
            
            docRef.getDocument { document, error in
                if let document = document, document.exists {
                    let data = document.data()
                    self.firstName = data?["firstName"] as? String ?? ""
                    self.lastName = data?["lastName"] as? String ?? ""
                    if let timestamp = data?["birthDate"] as? Timestamp {
                        self.birthDate = timestamp.dateValue()
                    }
                    self.email = data?["email"] as? String ?? ""
                } else {
                    print("Belge bulunamadı veya hata oluştu: \(error?.localizedDescription ?? "Hata yok")")
                }
            }
        } else {
            showAlert = true
            alertMessage = "Oturum açmış kullanıcı yok"
        }
    }
    
    func updateProfile() {
        if firstName.isEmpty || lastName.isEmpty {
            showAlert = true
            alertMessage = "Tüm alanları doldurun."
            return
        }
        
        if !newPassword.isEmpty {
            if newPassword != confirmPassword {
                showAlert = true
                alertMessage = "Yeni parolalar eşleşmiyor."
                return
            }
            
            if newPassword.count < 6 {
                showAlert = true
                alertMessage = "Yeni parola en az 6 karakter olmalıdır."
                return
            }
            
            let currentUser = Auth.auth().currentUser
            let credential = EmailAuthProvider.credential(withEmail: email, password: password)
            
            currentUser?.reauthenticate(with: credential, completion: { result, error in
                if let error = error {
                    showAlert = true
                    alertMessage = error.localizedDescription
                } else {
                    currentUser?.updatePassword(to: newPassword, completion: { error in
                        if let error = error {
                            showAlert = true
                            alertMessage = error.localizedDescription
                        } else {
                            showAlert = true
                            alertMessage = "Şifre başarıyla güncellendi."
                            self.presentationMode.wrappedValue.dismiss() // Profil güncellendikten sonra bir önceki sayfaya dön
                        }
                    })
                }
            })
        }
        
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser?.uid ?? ""
        let userData: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "birthDate": birthDate
        ]
        
        db.collection("users").document(userID).updateData(userData) { error in
            if let error = error {
                showAlert = true
                alertMessage = error.localizedDescription
            } else {
                showAlert = true
                alertMessage = "Profil başarıyla güncellendi"
                self.presentationMode.wrappedValue.dismiss() // Profil güncellendikten sonra bir önceki sayfaya dön
            }
        }
    }
}



struct ProfileSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileSettingsView()
        }
    }
}
