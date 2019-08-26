//
//  ProductViewController.swift
//  ARHat
//
//  Created by Jan Biernacki on 12/08/2019.
//  Copyright © 2019 Hattrick It. All rights reserved.
//

import Foundation
import VerticalCardSwiper

class ProductViewController: UIViewController, VerticalCardSwiperDatasource, VerticalCardSwiperDelegate {
    
    private var cardSwiper: VerticalCardSwiper!
    
    var currentModel: String = ""
    
    private let hats: [Hat] = [
        Hat(name: "Cap", price: 69.69, image: UIImage(named: "hat1")!, usdzName: "caphat"),
        Hat(name: "Beanie rasta", price: 6.66, image: UIImage(named: "hat2")!, usdzName: "beanietx"),
        Hat(name: "Beanie green", price: 213.7, image: UIImage(named: "hat3")!, usdzName: "BEANIEUSDZ")
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let viewFrame = self.view.alignmentRect(forFrame: self.view.bounds)
        
        let viewFrame = CGRect(x: 0.0, y: 64.0, width: 375, height: 603)
        
        cardSwiper = VerticalCardSwiper(frame: viewFrame)
        view.addSubview(cardSwiper)
        view.backgroundColor = UIColor.white
        
        cardSwiper.datasource = self
        cardSwiper.delegate = self
        
        // register cardcell for storyboard use
        cardSwiper.register(nib: UINib(nibName: "ExampleCell", bundle: nil), forCellWithReuseIdentifier: "ExampleCell")
    }
    
    func cardForItemAt(verticalCardSwiperView: VerticalCardSwiperView, cardForItemAt index: Int) -> CardCell {
        
        if let cardCell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: "ExampleCell", for: index) as? ExampleCardCell {
            
            cardCell.nameLabel.text = String(hats[index].name)
            cardCell.priceLabel.text = String(hats[index].price)
            cardCell.productImage.image = hats[index].image
            cardCell.setRandomBackgroundColor()
            
            return cardCell
        }
        return CardCell()
    }
    
    func didTapCard(verticalCardSwiperView: VerticalCardSwiperView, index: Int) {
        currentModel = hats[index].usdzName
        performSegue(withIdentifier: "menuToAR", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? FaceDetectViewController
        vc?.model = currentModel
    }
    
    /*func didTapCard(verticalCardSwiperView: VerticalCardSwiperView, index: Int) {
        print("Tapped \(index)")
        print(hats[index].usdzName)
        FaceDetectViewController().model = hats[index].usdzName
        performSegue(withIdentifier: "menuToAR", sender: self)
    } */
    
    func numberOfCards(verticalCardSwiperView: VerticalCardSwiperView) -> Int {
        return 3
    }
    @IBAction func buttonTapped(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "toAR", sender: self)
        
    }
    
}
