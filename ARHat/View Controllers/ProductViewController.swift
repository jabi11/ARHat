//
//  ProductViewController.swift
//  ARHat
//
//  Created by Jan Biernacki on 12/08/2019.
//  Copyright © 2019 Hattrick It. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

class ProductViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet var CollectionView: UICollectionView!
    private var currentHat: Hat!
    
    private let hats: [Hat] = [
        Hat(name: "Cap no.1", price: 120, image: UIImage(named: "newcap1.8")!, usdzName: "newcap1.8",position: SCNVector3(x: 0, y: 0.10, z: -0.01),scale: SCNVector3(x: 0.165 , y: 0.18, z: 0.165), tilt: SCNVector3(x: -0.2, y: 0, z: 0)),
        Hat(name: "Cylinder", price: 120, image: UIImage(named: "cap")!, usdzName: "cylinder1.1",position: SCNVector3(x: 0, y: 0.13, z: -0.075),scale: SCNVector3(x: 0.075 , y: 0.075, z: 0.075), tilt: SCNVector3(x: 0, y: 0, z: 0) ),
        Hat(name: "Beanie", price: 150, image: UIImage(named: "beaniefit1.6")!, usdzName: "beaniefit1.6",position: SCNVector3(x: 0, y: 0.115, z: -0.05),scale: SCNVector3(x: 0.17 , y: 0.17, z: 0.2), tilt: SCNVector3(x: -0.1, y: 0, z: 0)),
        Hat(name: "Pink Beanie", price: 150, image: UIImage(named: "beanie_pink")!, usdzName: "beaniepink1",position: SCNVector3(x: 0, y: 0.115, z: -0.05),scale: SCNVector3(x: 0.17 , y: 0.17, z: 0.2), tilt: SCNVector3(x: -0.1, y: 0, z: 0))
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CollectionView.delegate = self
        CollectionView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hats.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath) as! MenuCellClass
        
        cell.HatImage.image = hats[indexPath.row].image
        cell.HatName.text = String(hats[indexPath.row].name)
        cell.HatName.sizeToFit()
        cell.PriceLabel.text = String(hats[indexPath.row].price) + "PLN"
        cell.PriceLabel.sizeToFit()
        
        cell.callback = {
            addToCart(item: self.hats[indexPath.row])
        }
        
        
        cell.contentView.layer.cornerRadius = 2.0
//        //cell.contentView.layer.borderWidth = 1.0
//        //cell.contentView.layer.borderColor = UIColor.clear.cgColor
//        cell.contentView.layer.masksToBounds = true
//        cell.HatImage.layer.shadowOpacity = 0.0
//        cell.HatImage.layer.shadowRadius = 0.0
        
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)//CGSizeMake(0, 2.0);
        cell.layer.shadowRadius = 6.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentHat = hats[indexPath.row]
        performSegue(withIdentifier: "menuToInfo", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? InfoViewController
        vc?.currentHat = currentHat
    }
    
    
}
