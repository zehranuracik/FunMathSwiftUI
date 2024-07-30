import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct UserProfileView: View {
    @StateObject var viewModel = UserProfileViewModel()
    @State private var showingProfileSettings = false
    @State private var isSignedOut = false
    
    var body: some View {
        NavigationView {
            VStack {
                if let user = viewModel.user {
                    UserProfileDetailView(user: user)
                        .padding()
                    
                    Button(action: {
                        signOut()
                    }) {
                        Text("Çıkış Yap")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    .padding()
                    
                    Button(action: {
                        showingProfileSettings = true
                    }) {
                        Text("Profil Ayarları")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding()
                    }
                    .sheet(isPresented: $showingProfileSettings) {
                        ProfileSettingsView()
                    }
                } else {
                    ProgressView()
                }
            }
            .navigationTitle("Profil")
            .onAppear {
                viewModel.fetchUserData()
            }
            .background(
                NavigationLink(destination: ContentView(), isActive: $isSignedOut) {
                    EmptyView()
                }
                .hidden() // Keep it hidden from the UI
            )
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            isSignedOut = true
        } catch {
            print("Hesap çıkışı başarısız oldu: \(error.localizedDescription)")
        }
    }
}

struct UserProfileDetailView: View {
    var user: User
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .padding()
                
                VStack(alignment: .leading) {
                    Text("\(user.firstName) \(user.lastName)")
                        .font(.title)
                    
                    Text(user.email)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text("Doğum Tarihi: \(formattedDateString(date: user.birthDate))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding()
                
                Spacer()
            }
            VStack(alignment: .leading, spacing: 10) {
                Text("Toplama Başarısı: %\(String(format: "%.1f", user.additionSuccessRate))")
                Text("Çıkarma Başarısı: %\(String(format: "%.1f", user.subtractionSuccessRate))")
                Text("Çarpma Başarısı: %\(String(format: "%.1f", user.multiplicationSuccessRate))")
                Text("Bölme Başarısı: %\(String(format: "%.1f", user.divisionSuccessRate))")
            }
            .padding()
            
            Spacer()
        }
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 5)
    }
    
    private func formattedDateString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }
}

class UserProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoggedIn = false
    
    func fetchUserData() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Kullanıcı oturum açmamış")
            return
        }
        
        let db = Firestore.firestore()
        
        db.collection("users").document(userId).getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                let firstName = data?["firstName"] as? String ?? ""
                let lastName = data?["lastName"] as? String ?? ""
                let email = data?["email"] as? String ?? ""
                let birthTimestamp = data?["birthDate"] as? Timestamp
                let birthDate = birthTimestamp?.dateValue() ?? Date()
                
                // Başarı oranlarını almak için alt koleksiyonları sorgula
                let additionRef = db.collection("users").document(userId).collection("addition_quiz_succes_rate")
                let subtractionRef = db.collection("users").document(userId).collection("subtraction_quiz_succes_rate")
                let multiplicationRef = db.collection("users").document(userId).collection("multiplication_quiz_succes_rate")
                let divisionRef = db.collection("users").document(userId).collection("division_quiz_succes_rate")

                DispatchQueue.global().async {
                    let dispatchGroup = DispatchGroup()
                    
                    var additionSuccessRate: Double = 0
                    var subtractionSuccessRate: Double = 0
                    var multiplicationSuccessRate: Double = 0
                    var divisionSuccessRate: Double = 0
                    
                    // Tüm sorguların tamamlanmasını bekleyin
                    dispatchGroup.enter()
                    self.fetchSuccessRate(ref: additionRef) { successRate in
                        additionSuccessRate = successRate
                        dispatchGroup.leave()
                    }
                    
                    dispatchGroup.enter()
                    self.fetchSuccessRate(ref: subtractionRef) { successRate in
                        subtractionSuccessRate = successRate
                        dispatchGroup.leave()
                    }
                    
                    dispatchGroup.enter()
                    self.fetchSuccessRate(ref: multiplicationRef) { successRate in
                        multiplicationSuccessRate = successRate
                        dispatchGroup.leave()
                    }
                    
                    dispatchGroup.enter()
                    self.fetchSuccessRate(ref: divisionRef) { successRate in
                        divisionSuccessRate = successRate
                        dispatchGroup.leave()
                    }
                    
                    // Tüm sorgular tamamlandığında ana iş parçasına geri dön ve kullanıcıyı güncelle
                    dispatchGroup.notify(queue: .main) {
                        self.user = User(firstName: firstName, lastName: lastName, email: email, birthDate: birthDate, additionSuccessRate: additionSuccessRate, subtractionSuccessRate: subtractionSuccessRate, multiplicationSuccessRate: multiplicationSuccessRate, divisionSuccessRate: divisionSuccessRate)
                    }
                }
            } else {
                print("Kullanıcı bulunamadı: \(error?.localizedDescription ?? "Bilinmeyen hata")")
            }
        }
    }
    
    // Başarı oranlarını getirmek için sorgu fonksiyonu
    private func fetchSuccessRate(ref: CollectionReference, completion: @escaping (Double) -> Void) {
        ref.getDocuments { querySnapshot, error in
            if let documents = querySnapshot?.documents, let firstDocument = documents.first {
                let successRate = firstDocument["successRate"] as? Double ?? 0
                completion(successRate)
            } else {
                completion(0)
            }
        }
    }
}

struct User {
    var firstName: String
    var lastName: String
    var email: String
    var birthDate: Date
    var additionSuccessRate: Double
    var subtractionSuccessRate: Double
    var multiplicationSuccessRate: Double
    var divisionSuccessRate: Double
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}
