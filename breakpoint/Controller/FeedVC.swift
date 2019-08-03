//
//  FirstViewController.swift
//  breakpoint
//
//  Created by Ahmed on 7/28/19.
//  Copyright © 2019 Ahmed, ORG. All rights reserved.
//

import UIKit

class FeedVC: UIViewController {

    var messegeArray = [Messege]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DataService.instance.getAllFeedMesseges { (arr) in
            self.messegeArray = arr
            self.tableView.reloadData()
        }
    }

}

extension FeedVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messegeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FeedCell.self)) as? FeedCell else { return UITableViewCell() }
        let msg = messegeArray[indexPath.row]
        let img = #imageLiteral(resourceName: "defaultProfileImage")
        DataService.instance.getUsername(forUID: msg.senderId) { (userEmail) in
            cell.setup(img: img, email: userEmail, msg: msg.content)
        }
        
        return cell
        
    }
    
    
}
