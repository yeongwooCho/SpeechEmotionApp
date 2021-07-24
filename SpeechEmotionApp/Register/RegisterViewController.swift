//
//  RegisterViewController.swift
//  SpeechEmotionApp
//
//  Created by 조영우 on 2021/07/20.
//
import Firebase
import UIKit

class RegisterViewController: UIViewController {

    let color: UIColor = #colorLiteral(red: 0.2416285574, green: 0.2270267308, blue: 0.2228614092, alpha: 1)
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var extraView: UIView!
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordCheckTextField: UITextField!
    
    @IBOutlet weak var nameHintLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var emailHintLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var passwordHintLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var passwordCheckHintLabelHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerButtonUpdateUI()
        self.textFieldUnderLinedUpdate()
        self.hintLabelUpdateHeight([nameHintLabelHeight, emailHintLabelHeight, passwordHintLabelHeight, passwordCheckHintLabelHeight], height: 0)
    }

    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapBG(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func registerButtonHandler(_ sender: Any) {
        // 모든 TextField가 비어있을때 return
        if passwordCheckTextField.text!.isEmpty || passwordTextField.text!.isEmpty || emailTextField.text!.isEmpty || nameTextField.text!.isEmpty {
            return
        }
        
        // Hint Label이 존재할때 return
        if !(nameHintLabelHeight.constant == 0 &&
            emailHintLabelHeight.constant == 0 &&
            passwordHintLabelHeight.constant == 0 &&
            passwordCheckHintLabelHeight.constant == 0) {
            print("return할거야")
            let alert = UIAlertController(title: "회원가입 불가능", message: "모든 정보를 올바으게 입력해주세요", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "확인", style: .destructive, handler: nil))
            present(alert, animated: false, completion: nil)
            return
        }
        
        // 모든 TextField가 정상적인 값으로 입력되어 있을때
        let alert = UIAlertController(title: "회원가입 확인", message: "진짜 잘 확인했지?", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "그렇다!", style: .destructive) {_ in
            self.performSegue(withIdentifier: "completeRegister", sender: nil)
        }
        let cancelAction = UIAlertAction(title: "한번만 더보자!", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: false, completion: nil)
    }
    
    func registerButtonUpdateUI() {
        DispatchQueue.main.async {
            self.registerButton.layer.backgroundColor = self.color.cgColor
            self.registerButton.layer.cornerRadius = 10
        }
    }
    
    func textFieldUnderLinedUpdate() {
        DispatchQueue.main.async {
            self.nameTextField.underlined(viewSize: self.view.bounds.width, color: UIColor.systemGray)
            self.emailTextField.underlined(viewSize: self.view.bounds.width, color: UIColor.systemGray)
            self.passwordTextField.underlined(viewSize: self.view.bounds.width, color: UIColor.systemGray)
            self.passwordCheckTextField.underlined(viewSize: self.view.bounds.width, color: UIColor.systemGray)
        }
    }
    
    func hintLabelUpdateHeight(_ objects: [NSLayoutConstraint], height: CGFloat) {
        DispatchQueue.main.async {
            for object in objects {
                object.constant = height
            }
        }
    }
    
    // textField에 유효한 값이 들어오지 않으면 원하는 컨스트레인트를 변화시킨다?
    func normalizationCheck(_ textField: UITextField) {
        var regExKinds: String?
        var hintConstraint: NSLayoutConstraint?
        guard let id = textField.restorationIdentifier else { return }
        switch id {
        case "nameTextField":
            regExKinds = "nameRegEx"
            hintConstraint = nameHintLabelHeight
        case "emailTextField":
            regExKinds = "emailRegEx"
            hintConstraint = emailHintLabelHeight
        case "passwordTextField":
            regExKinds = "passwordRegEx"
            hintConstraint = passwordHintLabelHeight
        case "passwordCheckTextField":
            regExKinds = "passwordRegEx"
            hintConstraint = passwordCheckHintLabelHeight
        default:
            return
        }
        
        if Normalization.isValidRegEx(regExKinds: regExKinds, objectString: textField.text) {
            hintConstraint?.constant = 0
        } else {
            hintConstraint?.constant = 18
        }
    }
    
    func isEqualPassword() {
        DispatchQueue.main.async {
            if self.passwordTextField.text == self.passwordCheckTextField.text {
                self.passwordCheckHintLabelHeight.constant = 0
            } else {
                self.passwordCheckHintLabelHeight.constant = 18
            }
        }
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.underlined(viewSize: self.view.bounds.width, color: UIColor.systemOrange)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.underlined(viewSize: self.view.bounds.width, color: UIColor.systemGray)
        self.normalizationCheck(textField) // 문자열 정규식 체크
        if textField.restorationIdentifier == "passwordCheckTextField" {
            self.isEqualPassword() // 비밀번호 일치여부
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension RegisterViewController {
    @objc private func adjustInputView(noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        // 키보드 높이에 따른 인풋뷰 위치 변경
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        if noti.name == UIResponder.keyboardWillShowNotification {
            let adjustmentHeight = keyboardFrame.height
            guard let view = (self.view.currentFirstResponder() as? UITextField)?.superview else { return }
            scrollView.setContentOffset(CGPoint(x: 0, y: view.frame.maxY - adjustmentHeight + 100), animated: true)
        } else {
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
//        print("---> Keyboard End Frame: \(keyboardFrame)")
    }
}
