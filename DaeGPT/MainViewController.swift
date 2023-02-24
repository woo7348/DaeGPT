//
//  MainViewController.swift
//  DaeGPT
//
//  Created by 강민우 on 2023/02/23.
//

import UIKit
import FirebaseAuth

class MainViewController: UIViewController {
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true // 네비게이션바 숨기기
        
        let email = Auth.auth().currentUser?.email ?? "고객"
        
        welcomeLabel.text = "환영합니다. \(email)님 "
         
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true) // 로그아웃버튼을 눌렀을때 첫번째 화면으로 돌아감.
    }
}
