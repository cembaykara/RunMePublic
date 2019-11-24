//
//  HomeScreenView.swift
//  RunMe
//
//  Created by Baris Cem Baykara on 11/19/17.
//  Copyright © 2017 Baris Cem Baykara. All rights reserved.
//

import UIKit
import Firebase

class OldHomeScreenView: UIViewController {
    
    let fbUserId = UserDefaults.standard.string(forKey: "fbUserId")
    let refDB = Database.database().reference()
    let currentUser = Auth.auth().currentUser
    
    @IBOutlet weak var userInfo: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBAction func setToInit(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "HasLaunchedOnce")
    }
    
    @IBAction func signOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "loginScreen", sender: self)
        } catch  {
            print("error")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let user_email = currentUser?.email {userInfo.text = "Welcome \(user_email)"} else {userInfo.text = "Welcome"}
        if let data:NSData = NSData(contentsOf: (currentUser?.photoURL)!) {profilePicture.image = UIImage.init(data: data as Data)}
    }
}
