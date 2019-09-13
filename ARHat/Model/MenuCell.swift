//
//  MenuCell.swift
//  ARHat
//
//  Created by Jan Biernacki on 03/09/2019.
//  Copyright © 2019 Dress Me. All rights reserved.
//

import UIKit

class MenuCellClass: UICollectionViewCell {
    
    var callback: (()->Void)?
    
    @IBOutlet weak var HatImage: UIImageView!
    
    @IBOutlet weak var HatName: UILabel!
    
    @IBOutlet weak var PriceLabel: UILabel!
    
    @IBAction func addButton(_ sender: UIButton) {
        callback?()
    }
    
}
