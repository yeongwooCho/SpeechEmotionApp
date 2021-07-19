//
//  GroupCell.swift
//  SpeechEmotionApp
//
//  Created by 조영우 on 2021/07/05.
//

import UIKit

class GroupCell: UICollectionViewCell {
    @IBOutlet weak var groupNameLabel: UILabel!
    
    func updateUI(at index: Group) {
        DispatchQueue.main.async {
            self.groupNameLabel.text = index.groupName
        }
        print("여기 그룹업데이트", groupNameLabel.text)
    }
}
