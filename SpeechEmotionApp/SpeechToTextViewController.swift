//
//  SpeechToTextViewController.swift
//  SpeechEmotionApp
//
//  Created by 조영우 on 2021/06/29.
//

import UIKit
import Speech
import AVFoundation

class SpeechToTextViewController: UIViewController {

    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "ko-KR"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    @IBOutlet weak var myTextView: UITextView!
    @IBOutlet weak var translationButton: UIButton!
    @IBOutlet weak var stateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        speechRecognizer?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.myTextView.layer.cornerRadius = 5
        self.myTextView.text = "당신의 감정이 배경화면에 표시됩니다. 마이크를 클릭하고 말을 하면 당신의 감정을 분석해드립니다."
        self.stateLabel.text = "녹음하기"
    }
    
    @IBAction func speechToText(_ sender: Any) {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            translationButton.isEnabled = false
            self.stateLabel.text = "다시녹음하기"
            translationButton.isSelected = false
        } else {
            startRecording()
            stateLabel.text = "녹음중지"
            translationButton.isSelected = true
        }
    }
    
    @IBAction func analysisButtonHandler(_ sender: Any) {
//        guard let text = myTextView.text, text.isEmpty else { return }
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "AnalysisViewController") as! AnalysisViewController
//        vc.toAnalysisObject = text
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}

extension SpeechToTextViewController: SFSpeechRecognizerDelegate {
    func startRecording() {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            var isFinal = false
            if result != nil {
                self.myTextView.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                self.translationButton.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        myTextView.text = "지금 기분이 어때? 내가 들어줄게"
    }
        
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            translationButton.isEnabled = true
        } else {
            translationButton.isEnabled = false
        }
    }
}
