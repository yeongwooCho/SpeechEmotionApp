//
//  TextToSpeechViewController.swift
//  SpeechEmotionApp
//
//  Created by 조영우 on 2021/06/29.
//

import UIKit
import AVFoundation

class TextToSpeechViewController: UIViewController {

    @IBOutlet weak var myTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.myTextView.text = "오빤 맨날 그런식이야"
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func textToSpeechButtonHandler(_ sender: Any) {
        let synthesizer = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: myTextView.text)
        utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
        utterance.rate = 0.4
        utterance.pitchMultiplier = 1 // 0.5 ~ 2 낮을수록 남자같음
        synthesizer.speak(utterance)
    }
}
