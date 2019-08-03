//
//  GroupFeedVC.swift
//  breakpoint
//
//  Created by Ahmed on 8/1/19.
//  Copyright © 2019 Ahmed, ORG. All rights reserved.
//

import UIKit
import Firebase

class GroupFeedVC: UIViewController {

    @IBOutlet weak var groupTitleLbl: UILabel!
    @IBOutlet weak var membersLbl: UILabel!
    @IBOutlet weak var tablView: UITableView!
    @IBOutlet weak var sendUIView: UIView!
    @IBOutlet weak var msgTF: InsetTextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    var group: Group?
    var meesegeArray = [Messege]()
    
    func initData(group: Group){
        self.group = group
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        sendUIView.bindToKeyboard()
        msgTF.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        groupTitleLbl.text = group?.groupTitle
        DataService.instance.getAllEmails(forGroup: group!) { (emails) in
            self.membersLbl.text = emails.joined(separator: ", ")
        }
        
        DataService.instance.REF_GROUPS.observe(.value) { (snap) in
            DataService.instance.getMesseges(forGroup: self.group!, handler: { (msgs) in
                self.meesegeArray = msgs
                self.tablView.reloadData()
                
                if self.meesegeArray.count > 0 {
                    self.scrollingAuto()
                }
            })
        }
    }
    
    func scrollingAuto(){
        tablView.scrollToRow(at: IndexPath(row: self.meesegeArray.count - 1, section: 0), at: .none, animated: true)
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func sendBtnPressed(_ sender: Any) {
        if msgTF.text != ""{
            DataService.instance.uploadPost(withMessage: msgTF.text!, forUID: Auth.auth().currentUser!.uid, withGroupKey: group?.key) { (sent) in
                if sent{
                    self.msgTF.text = ""
                }
            }
        }
    }
    
}
extension GroupFeedVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()
        return true
    }
    
}

extension GroupFeedVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meesegeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablView.dequeueReusableCell(withIdentifier: GroupFeedCell.id) as! GroupFeedCell
        let msg = meesegeArray[indexPath.row]
        let img = #imageLiteral(resourceName: "defaultProfileImage")
        DataService.instance.getUsername(forUID: msg.senderId) { (username) in
            cell.setup(img: img, email: username, content: msg.content)
        }
        return cell
    }
    
    
}
