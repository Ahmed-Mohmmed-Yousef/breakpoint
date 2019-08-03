//
//  MeVC.swift
//  breakpoint
//
//  Created by Ahmed on 7/29/19.
//  Copyright © 2019 Ahmed, ORG. All rights reserved.
//

import UIKit
import Firebase
import Photos
import FBSDKLoginKit

class MeVC: UIViewController {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let uiview = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImg.addRoundedShadowBorder()
        editTap()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       loadProfileImg()
    }
    

    
    func loadProfileImg(){
        if let uid = Auth.auth().currentUser?.uid{
            DataService.instance.downloadProfileImg(forUser: uid) { (img) in
                if let img = img{
                    self.profileImg.image = img
                }
            }
        }
    }
    
    func uploadProfileImg(img: UIImage){
        DataService.instance.uploadProfileImg(img: img) { (isSuccess, url) in
            if isSuccess{
                if url != nil{
                    self.loadProfileImg()
                }
            }
        }
    }
    
    func editTap(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(editAction))
        tap.delegate = self as? UIGestureRecognizerDelegate
        profileImg.isUserInteractionEnabled = true
        profileImg.addGestureRecognizer(tap)
    }
    
    @IBAction func signOutWasPressed(_ sender: Any) {
        let logoutAlert = UIAlertController(title: "Logout", message: "Are you sure to logout?", preferredStyle: .alert)
        let logoutAction = UIAlertAction(title: "YES", style: .default) { (action) in
            do {
                LoginManager().logOut()
                try Auth.auth().signOut()
                let authVC = self.storyboard?.instantiateViewController(withIdentifier: String(describing: AuthVC.self)) as! AuthVC
                self.present(authVC, animated: true, completion: nil)
            } catch {
                print(error)
            }
        }
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
        
        logoutAlert.addAction(logoutAction)
        logoutAlert.addAction(cancelAction)
        present(logoutAlert, animated: true, completion: nil)
        
    }
    
    @objc func editAction() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            PHPhotoLibrary.requestAuthorization { (status) in
                switch status{
                case .authorized:
                    self.presentPhotoPickerController()
                    
                case .notDetermined:
                    if status == PHAuthorizationStatus.authorized{
                        self.presentPhotoPickerController()
                    }
                case .restricted:
                    let alert = UIAlertController(title: "Photo Library Restricted", message: "Photo Library is restricted and cannot be accessed", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default)
                    alert.addAction(okAction)
                    self.present(alert, animated: true)
                case .denied:
                    let alert = UIAlertController(title: "Photo Library Denied", message: "Photo Library is denied and cannot be accessed, Please go to setting and update it", preferredStyle: .alert)
                    let goToSetting = UIAlertAction(title: "go To Setting", style: .default, handler: { (action) in
                        DispatchQueue.main.async {
                            let url = URL(string: UIApplication.openSettingsURLString)
                            UIApplication.shared.open(url!, options: [:])
                        }
                    })
                    let cancel = UIAlertAction(title: "Cancel", style: .cancel)
                    
                    alert.addAction(cancel)
                    alert.addAction(goToSetting)
                    self.present(alert, animated: true)
                @unknown default:
                    break
                }
            }
        }
    }
    
    
    /// edit profile image
    fileprivate func presentPhotoPickerController() {
        let myPickerController = UIImagePickerController()
        myPickerController.allowsEditing = true
        myPickerController.delegate = self
        myPickerController.sourceType = .photoLibrary
        self.present(myPickerController, animated: true)
    }
    
}

extension MeVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage{
            //self.profileImg.image = image
            uploadProfileImg(img: image)
        }
        else if let image = info[.originalImage] as? UIImage{
            //self.profileImg.image = image
            uploadProfileImg(img: image)
        }
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
