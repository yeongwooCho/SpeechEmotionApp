//
//  RegisterCompleteViewController.swift
//  SpeechEmotionApp
//
//  Created by 조영우 on 2021/07/20.
//

import UIKit

class RegisterCompleteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}



//
//Auth.auth().createUser(withEmail: emailTextField.text!, password: pwTextField.text!
//
//        ) { (user, error) in
//
//            if user !=  nil{
//
//                print("register success")
//
//            }
//
//            else{
//
//                print("register failed")
//
//            }
//
//        }
//
//
//
//
