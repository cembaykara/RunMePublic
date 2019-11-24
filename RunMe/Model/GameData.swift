//
//  GameData.swift
//  RunMe
//
//  Created by Baris Cem Baykara on 11/18/17.
//  Copyright © 2017 Baris Cem Baykara. All rights reserved.
//

import MapKit

class GameData {
    
    var checkpoints = [String:Double]()
    var index = 1
    
    init(_ coordinates: [MKPointAnnotation]) {
        for pin in coordinates {
            checkpoints["lon\(index)"] = pin.coordinate.longitude
            checkpoints["lat\(index)"] = pin.coordinate.latitude
            index = index + 1
        }
    }
    
}
