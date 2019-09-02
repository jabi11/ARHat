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
    private var currentModel: String = ""
    
    private let hats: [Hat] = [
        Hat(name: "Cap", price: 69.69, image: UIImage(named: "cap")!, usdzName: "capdobre1"),
        Hat(name: "Beanie wool", price: 6.66, image: UIImage(named: "beanie")!, usdzName: "BEANIEDOBRE1")
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CollectionView.delegate = self
        CollectionView.dataSource = self
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath) as! MenuCellClass
        
        cell.HatImage.image = hats[indexPath.row].image
        cell.HatName.text = String(hats[indexPath.row].name)
        cell.PriceLabel.text = String(hats[indexPath.row].price)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentModel = hats[indexPath.row].usdzName
        performSegue(withIdentifier: "menuToAR", sender: self)
    }
    
   /* func didTapCard(verticalCardSwiperView: VerticalCardSwiperView, index: Int) {
        currentModel = hats[index].usdzName
        performSegue(withIdentifier: "menuToAR", sender: self)
    } */
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? FaceDetectViewController
        vc?.model = currentModel
    }
 
    
    
}
