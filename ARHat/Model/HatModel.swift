//
//  HatModel.swift
//  ARHat
//
//  Created by Jan Biernacki on 12/08/2019.
//  Copyright © 2019 Dress Me. All rights reserved.
//

import Foundation
import UIKit

class Hat {
    
    let name: String!
    let price: Float!
    let image: UIImage!
    let usdzName: String
    //TODO:  dodac property dla modelu w USDZ
    
    init(name: String, price: Float, image: UIImage, usdzName: String){
        self.name = name
        self.price = price
        self.image = image
        self.usdzName = usdzName
    }
}
