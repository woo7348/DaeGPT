//
//  EnterEmailViewController.swift
//  DaeGPT
//
//  Created by 강민우 on 2023/02/22.
//

import UIKit
import FirebaseAuth

class EnterEmailViewController : UIViewController {
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextfField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.layer.cornerRadius = 30
        nextButton.isEnabled = false
        emailTextField.delegate = self
        passwordTextfField.delegate = self
        
        emailTextField.becomeFirstResponder() // 새로 화면을 켰을때 화면의 커서가 emailTextField에 위치할 수 있게해줌.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Navigation Bar 보이기
        navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        //Firebase 이메일/비밀번호 인증
        let email = emailTextField.text ?? ""
        let password = passwordTextfField.text ?? ""
        
        //신규 사용자 생성
        Auth.auth().createUser(withEmail: email, password: password) {[weak self]   authResult, error in
            guard let self = self else { return }
            
            self.showMainViewController()
        }
    }
    
    private func showMainViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let mainViewController = storyboard.instantiateViewController(identifier: "MainViewController")
        mainViewController.modalPresentationStyle  = .fullScreen
        navigationController?.show(mainViewController, sender: nil)
    }
}

extension EnterEmailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let isEmailEmpty = emailTextField.text == ""
        let isPasswordEmpty = passwordTextfField.text == ""
        nextButton.isEnabled = !isEmailEmpty && !isPasswordEmpty
    }
    
}
