//
//  ProductViewController.swift
//  ARHat
//
//  Created by Jan Biernacki on 12/08/2019.
//  Copyright © 2019 Hattrick It. All rights reserved.
//

import Foundation
import UIKit

class ProductViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet var CollectionView: UICollectionView!
    private var currentHat: Hat!
    
    private let hats: [Hat] = [
        Hat(name: "Cap", price: 120, image: UIImage(named: "cap")!, usdzName: "capdobre1"),
        Hat(name: "Beanie", price: 150, image: UIImage(named: "beanie")!, usdzName: "BEANIEDOBRE1")
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
