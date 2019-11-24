//
//  FriendsList.swift
//  RunMe
//
//  Created by Baris Cem Baykara on 11/28/17.
//  Copyright © 2017 Baris Cem Baykara. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import CoreLocation

class FriendsList: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    //TODO: Fix optionals
    //TODO: Unplug from Storyboard
    
    
    
    let locationManager = CLLocationManager()
    var coordinates = [String:Double]()
    var fbUserId = UserDefaults.standard.string(forKey: "fbUserId")
    var myfriend = ""

    let tableView : UITableView = {
        let view = UITableView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.white
        return view
    }()
    
    var cellId = "friends"
    var users = [FBFriend]()
    
    
    func fetchUsers(){
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users/\(uid!)/friends").observe(.value) { (snapshot) in
            guard let friends = snapshot.value as? [[String:String]] else {return}
            for i in 0..<friends.count{
                let dict = friends[i]
                let fbFriends = FBFriend(name: dict["name"], id: dict["id"])
                self.users.append(fbFriends)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.startUpdatingLocation()
        coordinates = ["lat" : (locationManager.location?.coordinate.latitude)!, "lon" : (locationManager.location?.coordinate.longitude)!]
        if coordinates == ["lat" : (locationManager.location?.coordinate.latitude)!, "lon" : (locationManager.location?.coordinate.longitude)!] {
            locationManager.stopUpdatingLocation()
        }
        
        self.view.addSubview(tableView)
        fetchUsers()
        tableView.delegate = self
        tableView.dataSource = self
        gameInit()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "letsRun"{
            if let gameView = segue.destination as? GameView{
                gameView.friendId = myfriend
            }
        }
    }
    
    func isAccepted(_ id: String?){
        Database.database().reference().child("games/\(id!)/accepted").observe(.childAdded) { (checkIfAccepted) in
            if checkIfAccepted.exists(){
                let isAcceptedVal = checkIfAccepted.value as! Int
                if isAcceptedVal == 1  {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller : GameView = storyboard.instantiateViewController(withIdentifier: "GameView") as! GameView
                    controller.friendId = self.myfriend
                    self.present(controller, animated: true, completion: nil)
                    //                dismiss(animated: true, completion: nil)
                }else if isAcceptedVal == 0{
                    print("patates0")
                }


            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = users[indexPath.row]
        let values = ["fromID": UserDefaults.standard.string(forKey: "fbUserId")!,
                      "myCoordinates": coordinates] as [String : Any]
        let ref = Database.database().reference().child("games/\(selected.id!)")
            ref.setValue(values)
        myfriend = selected.id!
        isAccepted(selected.id)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func gameInit(){
        Database.database().reference().child("games").observe(.childAdded) { (snapshot) in
            if snapshot.key == UserDefaults.standard.string(forKey: "fbUserId"){
               let ref = Database.database().reference().child("games/\(snapshot.key)")
                ref.child("coordinates").setValue(self.coordinates)
                self.markerConfirmationAlert()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "friends")
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        return cell
    }
    
    func markerConfirmationAlert(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller : GameView = storyboard.instantiateViewController(withIdentifier: "GameView") as! GameView
        controller.friendId = myfriend
        let alertController = UIAlertController(title: "Match", message: "Your friend has requested a run", preferredStyle: UIAlertControllerStyle.alert)
        
        let resetAction = UIAlertAction(title: "Reset", style: UIAlertActionStyle.destructive) {
            (result : UIAlertAction) -> Void in
            return
        }
        
        let okAction = UIAlertAction(title: "Let's run!", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            Database.database().reference().child("games/\(UserDefaults.standard.string(forKey: "fbUserId")!)/accepted").setValue(["accepted" : 1])
            self.present(controller, animated: true, completion: nil)
        }
        
        alertController.addAction(resetAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
