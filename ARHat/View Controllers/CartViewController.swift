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
    
    override func viewDidLoad() {
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
        cell.cartPrice?.text = String(item.price)
        cell.cartImage?.image = item.image
        
        return cell
    }
    
    func updateTotal(){
        totalLabel.text = "Total: " + String(items.map({$0.price}).reduce(0, +))
    }
    
}

func addToCart(item: Hat){
    items.append(item)
}
