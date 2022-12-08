//
//  OrderItemTableViewCell.swift
//  ClearCreek
//
//  Created by Ali Sher on 05/12/2022.
//

import UIKit

class OrderItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var priceLbl: UILabel!
    
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var detailsLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
