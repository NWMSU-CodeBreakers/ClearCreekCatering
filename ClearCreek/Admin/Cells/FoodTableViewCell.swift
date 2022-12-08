//
//  FoodTableViewCell.swift
//  RestaurantApp
//
//  Created by Student on 05/12/2021.
//

import UIKit

class FoodTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var contantView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    
    @IBOutlet var deleteBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
