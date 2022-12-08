//
//  MenuTableViewCell.swift
//  ClearCreek
//
//  Created by Student on 13/09/2022.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet var imgView: UIImageView!
    @IBOutlet var nameLBL: UILabel!
    @IBOutlet var priceLBL: UILabel!
    @IBOutlet var detailsLBL: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
