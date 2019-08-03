//
//  CreateGroupVC.swift
//  breakpoint
//
//  Created by Ahmed on 7/30/19.
//  Copyright © 2019 Ahmed, ORG. All rights reserved.
//

import UIKit
import Firebase

class CreateGroupVC: UIViewController {

    var emailArry = [String]()
    var choosenUserArray = [String]()
    
    @IBOutlet weak var titleTF: InsetTextField!
    @IBOutlet weak var descriptionTF: InsetTextField!
    @IBOutlet weak var emailSearchTF: InsetTextField!
    @IBOutlet weak var groupMemberLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        emailSearchTF.delegate = self
        emailSearchTF.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
    }
    
    @objc func textFieldDidChanged(){
        if emailSearchTF.text == ""{
            emailArry = []
            tableView.reloadData()
        } else {
            DataService.instance.gitEmail(forQuerySearch: emailSearchTF.text!) { (emails) in
                self.emailArry = emails
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func doneWasPressed(_ sender: Any) {
        if titleTF.text?.count != 0 && descriptionTF.text?.count != 0{
            DataService.instance.getIds(forUserName: choosenUserArray) { (ids) in
                var userIds = ids
                userIds.append(Auth.auth().currentUser!.uid)
                
                DataService.instance.createGroup(forTitle: self.titleTF.text!, andDescription: self.descriptionTF.text!, forUserIds: userIds, handler: { (isDone) in
                    if isDone{
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        print("error accured during creating group")
                    }
                })
            }
        }
    }
    
    @IBAction func closeBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension CreateGroupVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailArry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.id) as? UserCell else {
            return UITableViewCell()
        }
        let img = #imageLiteral(resourceName: "defaultProfileImage")
        let isSelected = choosenUserArray.contains(emailArry[indexPath.row])
        cell.setup(img: img, email: emailArry[indexPath.row ], isSelected: isSelected)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? UserCell else { return }
        if !choosenUserArray.contains(cell.emailLbl.text!){
            choosenUserArray.append(cell.emailLbl.text!)
            groupMemberLbl.text = choosenUserArray.joined(separator: ", ")
        } else {
            choosenUserArray = choosenUserArray.filter({$0 != cell.emailLbl.text!})
            if choosenUserArray.count > 0 {
                groupMemberLbl.text = choosenUserArray.joined(separator: ", ")
            } else {
                groupMemberLbl.text = "add people to your group..."
            }
        }
    }
    
    
}

extension CreateGroupVC: UITextFieldDelegate{
    
}
