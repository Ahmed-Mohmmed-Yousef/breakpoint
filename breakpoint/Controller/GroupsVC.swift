//
//  GroupsVC.swift
//  breakpoint
//
//  Created by Ahmed on 7/28/19.
//  Copyright © 2019 Ahmed, ORG. All rights reserved.
//

import UIKit

class GroupsVC: UIViewController {

    @IBOutlet weak var groupTablView: UITableView!
    var groupsArray = [Group]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupTablView.delegate = self
        groupTablView.dataSource = self
        
        DataService.instance.REF_GROUPS.observe(.value) { (snaps) in
            DataService.instance.getAlGroup { (groups) in
                self.groupsArray = groups
                self.groupTablView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

}

extension GroupsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GroupCell.id) as! GroupCell
        let group = groupsArray[indexPath.row]
        cell.setup(groupTitle: group.groupTitle, description: group.groupDesc, members: "\(group.groupCount)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: String(describing: GroupFeedVC.self)) as! GroupFeedVC
        vc.initData(group: groupsArray[indexPath.row])
        present(vc, animated: true, completion: nil)
    }
}
