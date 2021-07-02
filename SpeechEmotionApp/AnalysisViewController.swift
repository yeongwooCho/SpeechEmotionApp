//
//  AnalysisViewController.swift
//  SpeechEmotionApp
//
//  Created by 조영우 on 2021/06/29.
//

import UIKit

class AnalysisViewController: UIViewController {

    var toAnalysisObject: String = ""
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var resultButton: UIButton!
    @IBOutlet weak var orangeGaugeView: UIView!
    @IBOutlet weak var heartView: UIButton!
    @IBOutlet weak var percentView: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.analysis(object: self.toAnalysisObject) // 분석
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showAnimation()
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resultButtonHandler(_ sender: Any) {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "TextToSpeechViewController") as! TextToSpeechViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    private func prepareAnimation() {
        self.orangeGaugeView.transform = CGAffineTransform(translationX: -view.bounds.width, y: 0)
        self.percentView.transform = CGAffineTransform(scaleX: 3, y: 3).translatedBy(x: 0, y: view.bounds.height).rotated(by: 180)
    }

    private func showAnimation() {
        UIView.animate(withDuration: 6.0, delay: 0.3, usingSpringWithDamping: 0.6, initialSpringVelocity: 2.0, options: .allowAnimatedContent, animations: {
            self.orangeGaugeView.transform = CGAffineTransform.identity
        }, completion: nil)
        
        UIView.animate(withDuration: 7.0) {
            self.percentView.transform = CGAffineTransform.identity
        } completion: { _ in
            self.titleLabel.text = "💓감정 분석 완료💓"
            self.descriptionLabel.text = "결과를 확인해주세요."
        }
        
        UIView.animate(withDuration: 2.0, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.heartView.frame = CGRect(x: 120, y: 220, width: 100, height: 100)
        }, completion: nil)
        
        UIView.transition(with: self.percentView, duration: 1.0, options: .transitionFlipFromRight, animations: nil, completion: nil)
    }
    
    func analysis(object: String) {
        for i in 1...1000000 {
            print(i)
        }
    }
}
