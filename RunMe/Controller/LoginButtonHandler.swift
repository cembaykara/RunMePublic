//
//  LoginButtonHandler.swift
//  RunMe
//
//  Created by Baris Cem Baykara on /15/18.
//  Copyright © 2018 Baris Cem Baykara. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase


class LoginButtonHandler {

    var controller: AnyObject!
    
    init(controller: AnyObject) {
        self.controller = controller
    }
    
    func login(with: LoginButton) {
        switch with {
            
        case .facebook:
            facebookLogin()
        case .google:
            print("implementation needed")
            
        }
    }
    
    func facebookLogin(){
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile", "user_friends"], from: controller as! UIViewController) { (user, error) in
            if error != nil {
                print(error as Any)
            }else if (user?.isCancelled)!{
                print("canceled")
            }else{
                print("\(String(describing: user))")
                let token = FacebookAuthProvider.credential(withAccessToken: (user?.token.tokenString)!)
                Auth.auth().signIn(with: token, completion: { (fbUser, fail) in
                    if fail != nil {
                        print("failed")
                    }else{
                        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, email, first_name, middle_name, last_name, friends, picture.height(720)"]).start(completionHandler: { (connection, user, failed) in
                            let user = user as! [String : AnyObject]
                            let fbUser = FBUser(user)
                            UserDefaults.standard.set(fbUser.userInfo["id"], forKey: "fbUserId")
                            let uid = Auth.auth().currentUser?.uid
                            Database.database().reference().child("users/\(uid!)").setValue(fbUser.userInfo)
                            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                            changeRequest?.photoURL = URL(string: fbUser.userInfo["url"] as! String)
                            changeRequest?.commitChanges(completion: nil)
                            self.controller.present(HomeScreenViewController(), animated: true, completion: nil)
                        })
                    }
                })
            }
        }
    }

    
}
