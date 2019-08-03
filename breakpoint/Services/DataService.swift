//
//  DataService.swift
//  breakpoint
//
//  Created by Ahmed on 7/28/19.
//  Copyright © 2019 Ahmed, ORG. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()
let STORAGE_REF = Storage.storage().reference()

class DataService{
    static let instance = DataService()
    
    var uid: String{
        return Auth.auth().currentUser!.uid
    }
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_GROUPS = DB_BASE.child("groups")
    private var _REF_FEED = DB_BASE.child("feed")
    private var _REF_STORAGE = STORAGE_REF.child("profileImage")
    
    var REF_BASE: DatabaseReference{
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference{
        return _REF_USERS
    }
    
    var REF_GROUPS: DatabaseReference{
        return _REF_GROUPS
    }
    var REF_FEED: DatabaseReference{
        return _REF_FEED
    }
    var REF_STORAGE: StorageReference{
        return _REF_STORAGE
    }
    
    /// CREATE NEW USER FUNC
    func createDBUser(uid: String, userData: Dictionary<String, Any>){
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    /// UPLOAD POST FUNC
    func uploadPost(withMessage msg: String, forUID uid: String, withGroupKey groupKey: String?, sendCompletion: @escaping(_ success: Bool) -> Void){
        if groupKey != nil{
            REF_GROUPS.child(groupKey!).child("messeges").childByAutoId().updateChildValues(["content": msg, "senderId": uid])
            sendCompletion(true)
        } else {
            REF_FEED.childByAutoId().updateChildValues(["content": msg, "senderId": uid])
            sendCompletion(true )
        }
    }
    
    /// GET USER EMAIL BY UID
    func getUsername(forUID uid: String, completion: @escaping(_ username: String) ->Void){
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snap) in
            completion(snap.childSnapshot(forPath: "email").value as! String)
        }
    }
    
    /// RETRIVE FEED ALL MESSEGES FUNC
    func getAllFeedMesseges(completion: @escaping(_ messeges: [Messege]) -> Void){
        var msgArr = [Messege]()
        REF_FEED.observeSingleEvent(of: .value) { (feedSnapshot) in
            guard let feedSnapshot = feedSnapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            for msg in feedSnapshot{
                let content = msg.childSnapshot(forPath: "content").value as! String
                let senderId = msg.childSnapshot(forPath: "senderId").value as! String
                let messege = Messege(content: content, senderId: senderId)
                msgArr.append(messege)
            }
            completion(msgArr)
        }
    }
    
    /// GET ALL FEED MESSEGES FOR GROUP
    func getMesseges(forGroup group: Group, handler: @escaping(_ msgsArray: [Messege]) -> Void){
        var msgsArray = [Messege]()
        REF_GROUPS.child(group.key).child("messeges").observeSingleEvent(of: .value) { (snap) in
            guard let msgSnaps = snap.children.allObjects as? [DataSnapshot] else { return }
            for msg in msgSnaps{
                let content = msg.childSnapshot(forPath: "content").value as! String
                let senderId = msg.childSnapshot(forPath: "senderId").value as! String
                let messge = Messege(content: content, senderId: senderId)
                msgsArray.append(messge)
            }
            handler(msgsArray)
        }
    }
    
    /// SEARCH QUETY
    func gitEmail(forQuerySearch query: String, handler: @escaping(_ emailArry: [String]) -> Void){
        var emailArry = [String]()
        REF_USERS.observe(.value) { (snap) in
            guard let userSnap = snap.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnap{
                let email = user.childSnapshot(forPath: "email").value as! String
                if email.contains(query) && email != Auth.auth().currentUser?.email {
                    emailArry.append(email)
                }
            }
            handler(emailArry)
        }
    }
    
    /// get Ids func
    func getIds(forUserName usernames: [String], handler: @escaping(_ uidArray: [String]) -> Void){
        var idArray = [String]()
        REF_USERS.observeSingleEvent(of: .value, with: { (snap) in
            guard let userSnap = snap.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnap{
                let email = user.childSnapshot(forPath: "email").value as! String
                if usernames.contains(email){
                    idArray.append(user.key)
                }
            }
            handler(idArray)
        })
    }
    
    /// GET ALL EMAILS IN GROUP
    func getAllEmails(forGroup group: Group, handler: @escaping(_ emailArray: [String]) -> Void){
        var emailArray = [String]()
        REF_USERS.observeSingleEvent(of: .value) { (snap) in
            let userSnaps = snap.children.allObjects as! [DataSnapshot]
            for user in userSnaps{
                if group.groupMembers.contains(user.key){
                    let email = user.childSnapshot(forPath: "email").value as! String
                    emailArray.append(email)
                }
            }
            handler(emailArray)
        }
    }
    
    ///CREATE GROUP FUNC
    func createGroup(forTitle title: String, andDescription description: String, forUserIds ids: [String], handler: @escaping(_ isCreated: Bool) -> Void){
        REF_GROUPS.childByAutoId().updateChildValues(["title": title, "description": description, "members": ids])
        handler(true)
    }
    
    //// GET ALL GROUP FUNC
    func getAlGroup(handler: @escaping(_ groupsArray: [Group]) -> Void){
        var groups = [Group]()
        REF_GROUPS.observeSingleEvent(of: .value) { (snap) in
            guard let allGroup = snap.children.allObjects as? [DataSnapshot] else { return }
            for group in allGroup{
                let memberArray = group.childSnapshot(forPath: "members").value as! [String]
                if memberArray.contains(self.uid){
                    let title = group.childSnapshot(forPath: "title").value as! String
                    let key = group.key
                    let desc = group.childSnapshot(forPath: "description").value as! String
                    let g = Group(groupTitle: title, groupDesc: desc, key: key, groupCount: memberArray.count, groupMembers: memberArray)
                    groups.append(g)
                }
            }
            handler(groups)
        }
    }
    
    /// UPLOAD PROFILE IMAGE
    func uploadProfileImg(img: UIImage, handler: @escaping(_ success: Bool, _ downloadUrl: URL?) -> Void){
        guard let uid = Auth.auth().currentUser?.uid, let imageData = img.jpegData(compressionQuality: 0.5) else {
            handler(false, nil)
            return
        }
        let storageRef = REF_STORAGE.child(uid)
        _ = storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if error != nil {
                print(error?.localizedDescription)
                handler(false, nil)
                return
            }
            // You can also access to download URL after upload.
            storageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    handler(false, nil)
                    return
                }
                handler(true, downloadURL)
            }
        }
    }
    
    /// download profileImage
    func downloadProfileImg(forUser uid: String, handler: @escaping(_ imge: UIImage?) -> Void){
        let storageRef = REF_STORAGE.child(uid)
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        storageRef.getData(maxSize: 1 * 512 * 512) { data, error in
            if  error != nil || data == nil {
                print(error?.localizedDescription)
                handler(nil)
            } else {
                let image = UIImage(data: data!)
                handler(image)
            }
        }
    }
}
