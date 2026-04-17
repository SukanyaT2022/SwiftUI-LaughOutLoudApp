import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    
    @State private var firstNameVar = ""
    @State private var lastNameVar = ""
    @State private var emailVar = ""
    @State private var passwordVar = ""
    @State private var showPassword = false
    @State private var errorMessage = ""
    @State private var successSignupAlertVar: Bool = false
    @State private var navigate2LoginVar: Bool = false
    var body: some View {
    NavigationStack {
        VStack(spacing: 20) {
            
            Spacer()
            
            // Title
            Text("Create Account")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Sign up to get started")
                .foregroundColor(.gray)
            
            InputCompView(text: $firstNameVar, placeholder: "First name")
            //apple native textfield
            InputCompView(text: $lastNameVar, placeholder: "Last name")
            InputCompView(text: $emailVar, placeholder: "Email")
         
            
            // Password
            VStack(alignment: .leading, spacing: 5) {
            
                HStack {
                    if showPassword {
                        InputCompView(text: $passwordVar, placeholder: "Password")
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
            
            // Sign Up Button
            Button(action: signUp) {
                Text("Sign Up")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Spacer()
        }
        //show alert if sign up successfully
        .alert(errorMessage, isPresented:$successSignupAlertVar, actions: {
            Button("OK") {
                self.navigate2LoginVar.toggle()
            }
        })
        //if log in sucess direct to log in screen
        .navigationDestination(isPresented: $navigate2LoginVar) {
            //below when it go to sign in after sign up sucess it will show email in sign in
              LoginView(emailVar: emailVar)
          }
        .padding()
        }
        
    }
    
  
    
    // MARK: - Sign Up Logic with firebase
    func signUp() {
        if emailVar.isEmpty || passwordVar.isEmpty {
            errorMessage = "Please fill in all fields"
            return
        }
        //firebase function
        Auth.auth().createUser(withEmail: emailVar, password: passwordVar) { result, error in
            successSignupAlertVar = true
            if let error = error {
                errorMessage = error.localizedDescription
                return
            }
            
            errorMessage = "Successfully sign up!"
            
            print("User created: \(result?.user.uid ?? "")")
        }
    }
}

#Preview {
    SignUpView()
}
