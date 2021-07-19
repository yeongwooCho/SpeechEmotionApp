//
//  UserCell.swift
//  SpeechEmotionApp
//
//  Created by 조영우 on 2021/07/05.
//

import UIKit

class UserCell: UICollectionViewCell {
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    func updateUI(at index: User) {
        DispatchQueue.main.async {
            self.userNameLabel.text = index.userName
            self.emailLabel.text = index.email
        }
    }
}
