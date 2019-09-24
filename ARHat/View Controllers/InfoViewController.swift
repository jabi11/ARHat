//
//  InfoViewController.swift
//  ARHat
//
//  Created by Jan Biernacki on 04/09/2019.
//  Copyright © 2019 Dress Me. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    //MARK: - OUTLETS
    
    @IBAction func ImageTapped(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "infoToAR", sender: self)
    }
    
    
    @IBAction func CheckoutTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "infoToCart", sender: self)
    }
    
    @IBOutlet weak var NameLabel: UILabel!
    
    @IBOutlet weak var PriceLabel: UILabel!
    @IBOutlet weak var HatImageView: UIImageView!
    
    var currentHat: Hat!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let navigationTitleImageView = UIImageView(image: UIImage(named: "dressmelogo1.0"))
        
        navigationItem.titleView = navigationTitleImageView
        navigationItem.titleView?.contentMode = .scaleAspectFit
        
        HatImageView.image = currentHat.image
        NameLabel.text = currentHat.name
        NameLabel.sizeToFit()
        PriceLabel.text = String(currentHat.price) + "PLN"
        PriceLabel.sizeToFit()
    }

    
    // MARK: - Navigation

    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "infoToAR" {
            let vc = segue.destination as? FaceDetectViewController
            vc?.model = currentHat.usdzName
            vc?.scale = currentHat.scale
            vc?.position = currentHat.position
            vc?.tilt = currentHat.tilt
            vc?.name = currentHat.name
        }
        
        if segue.identifier == "infoToCart" {
            addToCart(item: currentHat)
        }
        
    }

}
