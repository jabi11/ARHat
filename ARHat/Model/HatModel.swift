//
//  HatModel.swift
//  ARHat
//
//  Created by Jan Biernacki on 12/08/2019.
//  Copyright © 2019 Dress Me. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

class Hat {
    
    let name: String!
    let price: Float!
    let image: UIImage!
    let usdzName: String
    let scale: SCNVector3
    let position: SCNVector3
    let tilt: SCNVector3
    //TODO:  dodac property dla modelu w USDZ
    
    init(name: String, price: Float, image: UIImage, usdzName: String, position: SCNVector3, scale: SCNVector3, tilt: SCNVector3){
        self.name = name
        self.price = price
        self.image = image
        self.usdzName = usdzName
        self.position = position
        self.scale = scale
        self.tilt = tilt
    }
}
