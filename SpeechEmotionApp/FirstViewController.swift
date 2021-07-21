//
//  FirstViewController.swift
//  SpeechEmotionApp
//
//  Created by 조영우 on 2021/07/20.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loginButton.layer.borderColor = UIColor.black.cgColor
        self.loginButton.layer.borderWidth = 1
        self.loginButton.layer.cornerRadius = 10
        self.registerButton.layer.borderColor = UIColor.black.cgColor
        self.registerButton.layer.borderWidth = 1
        self.registerButton.layer.cornerRadius = 10
    }
    
    @IBAction func registerButtonHandler(_ sender: Any) {
        let sb = UIStoryboard.init(name: "Register", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "register") as! RegisterViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}
