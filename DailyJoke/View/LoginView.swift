import SwiftUI
import FirebaseAuth
struct LoginView: View {
    
    @State  var emailVar: String = ""
    @State private var passwordVar: String = ""
    @State private var showPassword: Bool = false
    @State private var errorMessage: String = ""
    
    @State private var navigate2HomeScreen: Bool = false
    @State private var successLoginAlertVar: Bool = false
    
    // MARK: - nor mal Login Logic
//    func login() {
//        if email.isEmpty || password.isEmpty {
//            errorMessage = "Please fill in all fields"
//            return
//        }
//        
//        if !email.contains("@") {
//            errorMessage = "Invalid email format"
//            return
//        }
//        
//        // Simulate login success
//        errorMessage = ""
//        print("Logging in with \(email)")
//    }
//    
    
    // login with fire base
    func login() {
        if emailVar.isEmpty || passwordVar.isEmpty {
            errorMessage = "Please fill in all fields"
            return
        }
        
        Auth.auth().signIn(withEmail: emailVar, password: passwordVar) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
                return
            }
            
            // Success
            errorMessage = ""
            print("User logged in: \(result?.user.uid ?? "")")
        }
    }
    
    var body: some View {
        
        NavigationStack {
            VStack(spacing: 20) {
                
                Spacer()
                
                // Title
                Text("Welcome Back")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Login to your account")
                    .foregroundColor(.gray)
                
                // Email Field
                VStack(alignment: .leading, spacing: 5) {
                    Text("Email")
                        .font(.caption)
                        .foregroundColor(.gray)
                  InputCompView(text: $emailVar, placeholder: "Enter your email")
                    
                   
                }
                
                // Password Field
                VStack(alignment: .leading, spacing: 5) {
                    Text("Password")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    HStack {
                        if showPassword {
                            InputCompView(text: $passwordVar, placeholder: "Enter your password")
                        } else {
                            SecureField("Enter your password", text: $passwordVar)
                        }
                        
                        Button(action: {
                            showPassword.toggle()
                        }) {
                            Image(systemName: showPassword ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                
                // Error Message
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                // Login Button-- login in () is login function
              
                    Button(action: login) {
                        Text("Login")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
               
             
                //sign up btn
                NavigationLink(destination: SignUpView()) {
                    Text("Sign Up")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                  
                }
                
//                .navigationDestination(isPresented: $navigate2LoginVar) {
//                    //below when it go to sign in after sign up sucess it will show email in sign in
//                      LoginView(emailVar: emailVar)
//                  }
                
                // Forgot Password
                Button("Forgot Password?") {
                    // Handle forgot password
                }
                .font(.footnote)
                
                Spacer()
            }
            .padding()
        }
    }
    
  
}

#Preview {
    LoginView()
}
