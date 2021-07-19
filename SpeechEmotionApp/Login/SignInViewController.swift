//
//  SignInViewController.swift
//  SpeechEmotionApp
//
//  Created by 조영우 on 2021/07/02.
//

import UIKit

class SignInViewController: UIViewController {
    
    let chatGroupViewController = ChatGroupViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func johnButtonTapped(_ sender: UIButton) {
        FirebaseDataService.instance.signIn(email: "jyy0223@naver.com", password: "1234qwer") {
            self.openChattingView()
        }
    }

    @IBAction func parkButtonTapped(_ sender: UIButton) {
        FirebaseDataService.instance.signIn(email: "thisisho@naver.com", password: "1234qwer") {
            self.openChattingView()
        }
    }

    func openChattingView() {
        self.performSegue(withIdentifier: "chatGroup", sender: nil)
    }
}
