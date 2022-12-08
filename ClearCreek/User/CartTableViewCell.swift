//
//  CartTableViewCell.swift
//  ClearCreek
//
//  Created by Student on 14/09/2022.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    @IBOutlet var contantView: UIView!
    @IBOutlet var checkBtn: UIButton!
    @IBOutlet var imgView: UIImageView!
    
    @IBOutlet var nameLBL: UILabel!
    @IBOutlet var ratingLBL: UILabel!
    
    @IBOutlet var minusBtn: UIButton!
    @IBOutlet var counterLBL: UILabel!
    @IBOutlet var plusBtn: UIButton!
    
    @IBOutlet var priceLBL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
