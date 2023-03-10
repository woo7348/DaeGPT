//
//  LoginViewController.swift
//  DaeGPT
//
//  Created by 강민우 on 2023/02/22.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import AuthenticationServices
import CryptoKit

struct LoginType {
    static var name: String = ""
}

class LoginViewController: UIViewController, ASAuthorizationControllerDelegate {
    
    @IBOutlet weak var emailLoginButton: UIButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    @IBOutlet weak var googleLoginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [emailLoginButton, googleLoginButton, appleLoginButton
        ].forEach {
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor.white.cgColor
            $0?.layer.cornerRadius = 30 
        }
    }
     
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Navigation Bar 숨기기
        navigationController?.navigationBar.isHidden = true
    }
    @IBAction func googleLoginButtonTapped(_ sender: Any) {
        guard let LoginnedViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginnedViewController") as? LoginnedViewController else { return }
        let config = GIDConfiguration(clientID: "1073742045305-2tku010ljbkqbrgqi8h6knnv8ua40edk.apps.googleusercontent.com")
        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(withPresenting: self) {
            user, error in
            if error != nil { return }
            guard let user = user else { return }

            print(user.user.userID ?? <#default value#> as Any)
            print(user.user.accessToken)
            print(user.user.profile?.email ?? <#default value#>)
            print(user.user.profile?.name ?? <#default value#>)
            LoginType.name = "Google"
            self.navigationController?.pushViewController(LoginnedViewController, animated: true)
        }
    }
    
    @IBAction func signOut(sender: Any) {
      GIDSignIn.sharedInstance.signOut()
    }
}

@IBAction func appleLoginButtonTapped(_ sender: Any) {
    //startSignInWithAppleFlow()
}

extension LoginViewController: ASAuthorizationControllerDelegate {
func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
        guard let nonce = currentNonce else {
            fatalError("Invalid state: A login callback was received, but no login request was sent.")
        }
        guard let appleIDToken = appleIDCredential.identityToken else {
            print("Unable to fetch identity token")
            return
        }
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            return
        }

        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)

        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                print ("Error Apple sign in: %@", error)
                return
            }
            // User is signed in to Firebase with Apple.
            // ...
            ///Main 화면으로 보내기
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let loginnedViewController = storyboard.instantiateViewController(identifier: "LoginnedViewController")
            LoginType.name = "Apple"
            self.navigationController?.pushViewController(loginnedViewController, animated: true)
        }
    }
}
}

//Apple Sign in
extension LoginViewController {
func startSignInWithAppleFlow() {
    let nonce = randomNonceString()
    currentNonce = nonce
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let request = appleIDProvider.createRequest() // 릴레이 공격방지
    request.requestedScopes = [.fullName, .email]
    request.nonce = sha256(nonce)

    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.delegate = self
    authorizationController.presentationContextProvider = self
    authorizationController.performRequests()
}

private func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
    }.joined()

    return hashString
}

// Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
private func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length

    while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
            var random: UInt8 = 0
            let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
            if errorCode != errSecSuccess {
                fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
            }
            return random
        }

        randoms.forEach { random in
            if remainingLength == 0 {
                return
            }

            if random < charset.count {
                result.append(charset[Int(random)])
                remainingLength -= 1
            }
        }
    }

    return result
}
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return self.view.window!
}
}


