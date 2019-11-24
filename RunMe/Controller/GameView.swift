//
//  GameView.swift
//  RunMe
//
//  Created by Baris Cem Baykara on 11/16/17.
//  Copyright © 2017 Baris Cem Baykara. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase
import Contacts
import SVProgressHUD

class GameView: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //TODO: Rewrite Game logic
    
    @IBOutlet weak var mapview: MKMapView!
    @IBOutlet weak var mapview2: MKMapView!
    let card = Card()
    var collectionView: UICollectionView!
    let layout = UICollectionViewFlowLayout()
    
    @IBOutlet weak var constraint: NSLayoutConstraint!
    
    let myId = UserDefaults.standard.string(forKey: "fbUserId")
    let geoCoder = CLGeocoder()
    let locationManager = CLLocationManager()
    var userLocation = CLLocationCoordinate2D()
    var annotations = [MKPointAnnotation]()
    var selectedPin = MKPointAnnotation()
    var friendId = ""
    var whoDid : Int? = nil //0 for opponent 1 for current player
    let request = MKDirectionsRequest()
    
    
    @IBAction func tap(_ sender: UILongPressGestureRecognizer) {
        if sender.state != UIGestureRecognizerState.began { return }
        let touchLocation = sender.location(in: mapview)
        let locationCoordinate = mapview.convert(touchLocation, toCoordinateFrom: mapview)
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = locationCoordinate
        annotations.append(annotation)
        mapview.addAnnotations(annotations)
        
        if annotations.count == 3 {
            markerConfirmationAlert()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        
        collectionView.autoSetDimension(.height, toSize: card.height + 32)
        collectionView.collectionViewLayout = layout
        collectionView.register(Card.self, forCellWithReuseIdentifier: "card")
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isHidden = true
        collectionView.showsHorizontalScrollIndicator = false
        
        view.addSubview(collectionView)
        
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
       mapview2.delegate = self
        
        if ((locationManager.location?.coordinate) != nil) {
            mapSetup()
        }else{
            let locationErrorPopup = UIAlertController(title: "Oh, no!", message: "Seems like location services are off. Please enable location services", preferredStyle: UIAlertControllerStyle.alert)
            
            let locationErrorPopupAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
            }
            
            locationErrorPopup.addAction(locationErrorPopupAction)
            self.present(locationErrorPopup, animated: true, completion: nil)
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let refDB = Database.database().reference().child("games")
        
        if whoDid == 1 {
            refDB.child("\(friendId)").observe(.value) { (winner) in
                if winner.exists(){
                    guard let winnerData = winner.value as? [String:String] else {return}
                    if winnerData["winner"] == self.myId {
                       // self.dismiss(animated: true, completion: nil)
                        self.show(winner: "")
                        print("you won")
                    }else {
                      //  self.dismiss(animated: true, completion: nil)
                        self.show(winner: "")
                        print("you lose")
                    }
                }
            }
        }else if whoDid == 0 {
            refDB.child("\(myId!)").observe(.value) { (winner) in
                if winner.exists(){
                    guard let winnerData = winner.value as? [String:String] else {return}
                    if winnerData["winner"] == self.myId {
                        print("you won")
                       // self.dismiss(animated: true, completion: nil)
                    }else {
                       // self.dismiss(animated: true, completion: nil)
                        print("you lose")
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var constraintsUpdated = false
    
    override func updateViewConstraints() {
        if !constraintsUpdated {
            collectionView.autoPinEdge(toSuperviewEdge: .right)
            collectionView.autoPinEdge(toSuperviewEdge: .left)
            collectionView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 34.0)
            collectionView.autoPinEdgesToSuperviewEdges(with: view.safeAreaInsets, excludingEdge: .top)
        }
        constraintsUpdated = true
        
        super.updateViewConstraints()
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.customBlue.steelBlue
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }else if overlay is MKCircle{
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.strokeColor = UIColor.customBlue.steelBlue
            circleRenderer.fillColor = UIColor.customBlue.steelBlue.withAlphaComponent(0.2)
            circleRenderer.lineWidth = 1
            return circleRenderer
        }
        
        return MKOverlayRenderer()
    }
    
    func mapHelper(data: [String:Double]){
        var opponentCoordinates = CLLocationCoordinate2D()
        opponentCoordinates.latitude = data["lat"]!
        opponentCoordinates.longitude = data["lon"]!
        self.userLocation = self.locationManager.location!.coordinate
        
        let map2Area = MKCoordinateRegionMakeWithDistance(self.userLocation, 1500, 1500)
        let mapArea = MKCoordinateRegionMakeWithDistance(opponentCoordinates, 1500, 1500)
        
        self.mapview.setCenter(opponentCoordinates, animated: false)
        self.mapview.setRegion(mapArea, animated: true)
        self.mapview2.setCenter(self.userLocation, animated: true)
        self.mapview2.setRegion(map2Area, animated: false)
        self.mapview2.showsUserLocation = true
    }
    
    func mapSetup(){
        let refDB = Database.database().reference().child("games")
        
        refDB.child("\(myId!)/myCoordinates").observe(.value) { (snapshot) in
            if snapshot.exists(){
                guard let data = snapshot.value as? [String:Double] else {return}
                self.mapHelper(data: data)
                self.whoDid = 0
            }
        }
        refDB.child("\(friendId)/coordinates").observe(.value) { (snapshot) in
            if snapshot.exists(){
                guard let data = snapshot.value as? [String:Double] else {return}
                self.mapHelper(data: data)
                self.whoDid = 1
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let overlays = mapview2.overlays
        userLocation = (locationManager.location?.coordinate)!
        let pinLocation = CLLocation(latitude: selectedPin.coordinate.latitude, longitude: selectedPin.coordinate.longitude)
        
        if locationManager.location!.distance(from: pinLocation) < 30.0 {
            mapview2.removeAnnotation(selectedPin)
            mapview2.removeOverlays(overlays)
            
            for pinind in annotations{
                if pinind == selectedPin {
                    if let index = annotations.index(of:pinind){
                        annotations.remove(at: index)
                        if annotations.count == 0 {
                            sendWinner()
                        }
                    }
                }
            }
            collectionView.reloadData()
        }
        
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: selectedPin.coordinate))
        request.transportType = .walking
        
        let directions = MKDirections(request: request)
        directions.calculate { (path, error) in
            if error != nil {
                print("shitso")
            }else {
                self.mapview2.removeOverlays(overlays)
                self.mapview2.add((path?.routes.first?.polyline)!)
                self.addRadius(toPin: self.selectedPin)
            }
        }
        
        if !collectionView.isHidden {
            collectionView.reloadData()
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return annotations.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "card", for: indexPath) as! Card
        let pin = annotations[indexPath.row]
        cell.header.text = pin.subtitle
        
        let destination = CLLocation(latitude: pin.coordinate.latitude, longitude: pin.coordinate.longitude)
        let user = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let distance = destination.distance(from: user)
        cell.distance.text = String(format: "%.2fm", distance)
        
        cell.icon.image = #imageLiteral(resourceName: "Image")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        if !collectionView.isHidden {
            let pin = annotations[indexPath.row]
            let overlays = mapview2.overlays
            mapview2.removeOverlays(overlays)
            selectedPin = pin
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: pin.coordinate))
            request.transportType = .walking
            
            let directions = MKDirections(request: request)
            
            directions.calculate { (path, error) in
                if error != nil {
                    print("shitso")
                } else {
                    self.mapview2.add((path?.routes.first?.polyline)!)
                    self.addRadius(toPin: pin)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width-64, height: card.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath: IndexPath? = collectionView.indexPathForItem(at: visiblePoint)
        
        guard let indexPath = visibleIndexPath else { return }
        //containerView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        collectionView(collectionView, didSelectItemAt: indexPath)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var insets = self.collectionView.contentInset
        let value:CGFloat = 32.0
        insets.left = value
        insets.right = value
        self.collectionView.contentInset = insets
        self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    }
    
    
    func addRadius(toPin:MKPointAnnotation) {
        let circle = MKCircle(center: toPin.coordinate, radius: 30.0)
        mapview2.add(circle)
    }
    
    func sendWinner () {
        let refDB = Database.database().reference().child("games")
        var winner = [String:String]()
        winner["winner"] = myId
        if whoDid == 1 {
            refDB.child("\(friendId)").setValue(winner, withCompletionBlock: { (error, ref) in
                if error != nil{
                    print("shit mama")
                }
            })
        }else if whoDid == 0 {
            refDB.child("\(myId!)").setValue(winner, withCompletionBlock: { (error, ref) in
                if error != nil{
                    print("shit mama")
                }
            })
        }
    }
    
    // FIXME: photoUrl broadcasting in game node needed
    func show(winner: String) {
        let winnerScreen = WinnerScreen()
        let data: NSData = try! NSData(contentsOf: (Auth.auth().currentUser?.photoURL)!)
        winnerScreen.image.image = UIImage.init(data: data as Data)
        view.addSubview(winnerScreen)
        winnerScreen.autoCenterInSuperview()
        view.updateConstraints()
    }
    
    func markerConfirmationAlert(){
        let alertController = UIAlertController(title: "Are you done?", message: "Do you want to send the locations to your opponent?", preferredStyle: UIAlertControllerStyle.alert)
        
        let resetAction = UIAlertAction(title: "Reset", style: UIAlertActionStyle.destructive) {
            (result : UIAlertAction) -> Void in
            self.mapview.removeAnnotations(self.annotations)
            self.annotations.removeAll()
        }
        
        let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            self.send(coordinates: self.annotations)
            self.annotations.removeAll()
        }
        
        alertController.addAction(resetAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func send(coordinates: [MKPointAnnotation]) {
        let gameData = GameData(coordinates)
        print(gameData.checkpoints)
        var gameDB = Database.database().reference()
        
        if whoDid == 0 {
            gameDB = Database.database().reference().child("games/\(myId!)/myCoordinates/Checkpoints")
        }else if whoDid == 1 {
            gameDB = Database.database().reference().child("games/\(friendId)/coordinates/Checkpoints")
        }
        
        gameDB.setValue(gameData.checkpoints) { (error, ref) in
            if error != nil {
                print("There was an error")
            }
        }
        
        SVProgressHUD.show()
        receive(whoDid!)
    }
    
    
    func receive(_ whoDid : Int){
        var ref = Database.database().reference()
        
        if whoDid == 1 {
            ref = ref.child("games/\(friendId)/myCoordinates/Checkpoints")
        } else if whoDid == 0 {
            ref = ref.child("games/\(myId!)/coordinates/Checkpoints")
        }
        
        ref.observe(.value) { (snapshot) in
            if snapshot.exists(){
                self.annotations.removeAll()
                
                if let coordinates = snapshot.value as? [String:Double] {
                    for index in 1...3 {
                        let receivedAnnotation = MKPointAnnotation()
                        receivedAnnotation.coordinate.latitude = coordinates["lat\(index)"]!
                        receivedAnnotation.coordinate.longitude = coordinates["lon\(index)"]!
                        receivedAnnotation.subtitle = "Checkpoint \(index)"
                        self.annotations.append(receivedAnnotation)
                    }
                }
                
            }
            
            if self.annotations.count == 3 {
                SVProgressHUD.dismiss()
                self.mapview2.addAnnotations(self.annotations)
                
                UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.transitionCurlUp, animations: {
                    self.mapview.transform = CGAffineTransform(translationX: 0.0, y: (self.view.frame.height/2)*(-1))
                    self.constraint.constant = self.view.frame.height
                    self.mapview2.layoutIfNeeded()
                }, completion:{whenFinished in self.mapview.removeFromSuperview()
                    
                    self.mapview2.setCenter(self.userLocation, animated: true)
                    self.collectionView.isHidden = false
                    self.collectionView.reloadData()
                })
            }
        }
    }
}

