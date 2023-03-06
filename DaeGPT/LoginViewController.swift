//
//  LoginViewController.swift
//  DaeGPT
//
//  Created by 강민우 on 2023/02/22.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailLoginButton: UIButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    @IBOutlet weak var googleLoginButton: GIDSignInButton!
    
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
    
    let id = "00000000000000000000000";)
    let signInConfig = GIDConfiguration(clientID: id)
    
    @IBAction func googleLoginButtonTapped(_ sender: GIDSignInButton) {
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self.signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
            guard let user = user else { return }
            
            user.authentication.do { [self] authentication, error in
                guard error == nil else { print(error); return }
                guard let authentication = authentication else { return }
                
                let idToken = authentication.idToken
            }
        }
    }
    @IBAction func appleLoginButtonTapped(_ sender: UIButton) { //firebase 인증
    }
}
