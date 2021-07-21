//
//  ChatGroupViewController.swift
//  SpeechEmotionApp
//
//  Created by 조영우 on 2021/07/02.
//

import UIKit

class ChatGroupViewController: UIViewController {

    var groups: [Group] = []
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchChatGroupList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userList" {
            let userListVC = segue.destination as! UserListViewController
            let chatGroupVC = sender as? ChatGroupViewController
            userListVC.chatGroupVC = chatGroupVC
        }
//        else if segue.identifier == "chatRoom" {
//            let chatVC = segue.destination as! ChatRoomViewController
//            chatVC.groupKey = sender as? String
//        }
    }
    
    @IBAction func userListButtonHandler(_ sender: Any) {
        performSegue(withIdentifier: "userList", sender: self)
    }
    
    func fetchChatGroupList() {
        if let uid = FirebaseDataService.instance.currentUserUid {
            FirebaseDataService.instance.usersRef.child(uid).child("groups").observeSingleEvent(of: .value, with: { (snapshot) in
                if let dict = snapshot.value as? Dictionary<String, Int> {
                    for (key, _) in dict {
                        
                        FirebaseDataService.instance.groupsRef.child(key).observeSingleEvent(of: .value, with: { (snapshot) in
                            if let data = snapshot.value as? Dictionary<String, AnyObject> {
                                let group = Group(key: key, data: data)
                                self.groups.append(group)
                                
                                DispatchQueue.main.async(execute: {
                                    self.collectionView.reloadData()
                                })
                            }
                        })
                    }
                }
            })
        }
    }
}

extension ChatGroupViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.groups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupCell", for: indexPath) as? GroupCell else {
            return UICollectionViewCell()
        }
        cell.updateUI(at: groups[indexPath.item])
        return cell
    }
}

extension ChatGroupViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "chatRoom", sender: groups[indexPath.item].key)
//        let chatVC = segue.destination as! ChatRoomViewController
//        chatVC.groupKey = sender as? String
        
        
//        let sb = UIStoryboard.init(name: "Main", bundle: nil)
//        let vc = sb.instantiateViewController(identifier: "ChatRoomViewController") as! ChatRoomViewController
//        vc.modalPresentationStyle = .fullScreen
//        vc.groupKey = groups[indexPath.item].key
//        present(vc, animated: true, completion: nil)
    }
}

extension ChatGroupViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = view.bounds.width
        let height: CGFloat = 100
        return CGSize(width: width, height: height)
    }
}

class GroupCell: UICollectionViewCell {
    func updateUI(at index: Group) {
        
    }
}
