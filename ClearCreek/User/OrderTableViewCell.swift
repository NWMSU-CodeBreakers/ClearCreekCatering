//
//  OrderTableViewCell.swift
//  ClearCreek
//
//  Created by Student on 14/09/2022.
//

import UIKit

class OrderTableViewCell: UITableViewCell {
    
    @IBOutlet var contantView: UIView!
    @IBOutlet var dateLBL: UILabel!
    @IBOutlet var priceLBL: UILabel!
    @IBOutlet var itemsLBL: UILabel!
    
    @IBOutlet var statusLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
