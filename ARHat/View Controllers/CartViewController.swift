//
//  CartViewController.swift
//  ARHat
//
//  Created by Jan Biernacki on 27/08/2019.
//  Copyright © 2019 Dress Me. All rights reserved.
//

import Foundation
import UIKit

private var items: [Hat] = []

class CartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cartImage: UIImageView!
    @IBOutlet weak var cartName: UILabel!
    @IBOutlet weak var cartPrice: UILabel!
    
}



class CartViewController: UITableViewController{
    
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var footerView: UIView!
    
    
    override func viewDidLoad() {
        self.tableView.separatorStyle = .none
        
        updateTotal()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartTableViewCell
        
        let item = items[indexPath.row]
        
        cell.cartName?.text = item.name
        cell.cartName?.sizeToFit()
        cell.cartPrice?.text = String(item.price) + "PLN"
        cell.cartPrice?.sizeToFit()
        cell.cartImage?.contentMode = .scaleAspectFill
        cell.cartImage?.image = item.image
        cell.cartImage?.layer.shadowColor = UIColor.lightGray.cgColor
        cell.cartImage?.layer.shadowOpacity = 1.0
        cell.cartImage?.layer.shadowRadius = 10.0
        cell.cartImage?.layer.shadowOffset = .zero
        let layer = cell.cartImage?.layer
        cell.cartImage?.layer.shadowPath = UIBezierPath(rect: CGRect(x: 0,
                                                                     y: cell.cartImage.bounds.maxY - layer!.shadowRadius,
                                                                     width: cell.cartImage.bounds.width,
                                                                     height: layer!.shadowRadius)).cgPath
        
        return cell
    }
    
    func updateTotal(){
        totalLabel.text = String(items.map({$0.price}).reduce(0, +)) + "PLN"
    }
    
}

func addToCart(item: Hat){
    items.append(item)
}
