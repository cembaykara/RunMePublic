//
//  WelcomeScreenView.swift
//  k
//
//  Created by Baris Cem Baykara on 11/10/17.
//  Copyright © 2017 Baris Cem Baykara. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class OldWelcomeScreenView: UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet weak var allowLocation: UIButton!
    @IBOutlet weak var denyLocation: UIButton!
    @IBOutlet weak var LocationText: UILabel!
    @IBOutlet weak var flyOver: MKMapView!
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        denyLocation.layer.borderWidth = 2.0
        denyLocation.layer.borderColor = UIColor.white.cgColor
        denyLocation.layer.opacity = 0.85
        denyLocation.layer.cornerRadius = 25.0
        denyLocation.setTitle("Nope, I don't want to run", for: .normal)
        denyLocation.alpha = 0.85
        
        allowLocation.layer.borderWidth = 2.0
        allowLocation.layer.borderColor = UIColor.white.cgColor
        allowLocation.layer.opacity = 0.85
        allowLocation.layer.cornerRadius = 25.0
        allowLocation.setTitle("Yes, allow location access", for: .normal)
        allowLocation.alpha = 0.85
        
        flyOver.mapType = .satelliteFlyover
        flyOver.showsCompass = false
        let coordinates = CLLocationCoordinate2D(latitude: 37.8258, longitude: -122.4793)
        let camera = MKMapCamera(lookingAtCenter: coordinates, fromDistance: 650, pitch: 45, heading: 0)
        
        flyOver.camera = camera
        
        UIView.animate(withDuration: 15.0, animations: {
            camera.heading += 180
            camera.pitch = 65
            self.flyOver.camera = camera
        })
        LocationText.text = "We need your location for awesome running"
        
        locationManager.delegate = self
    }

    
    @IBAction func allowLocation(_ sender: UIButton) {
        if sender.tag == 1{
            locationManager.requestWhenInUseAuthorization()
            if locationPermission() {
                allowLocation.setTitle("Location Enabled", for: .normal)
            }else{
                locationAlert()
            }
        }else if sender.tag == 2{
                locationAlert()
        }
    }
    
    func locationPermission() -> Bool{
        var isEnabled = true
        
        locationManager.requestWhenInUseAuthorization()
        
            switch (CLLocationManager.authorizationStatus()) {
                
            case .notDetermined, .denied, .restricted:
                isEnabled = false
            case .authorizedWhenInUse, .authorizedAlways:
                isEnabled = true
            }
        
        return isEnabled
    }
    
    func locationAlert(){
        
        if (!locationPermission()){
        let alertController = UIAlertController(title: "Sorry", message: "To run, you need to allow location permissions", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "Warning", message: "Seems like you have already enabled location services.", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
            }
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
    }
}
}
