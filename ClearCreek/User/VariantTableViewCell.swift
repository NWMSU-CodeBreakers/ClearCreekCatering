//
//  VariantTableViewCell.swift
//  ClearCreek
//
//  Created by Student on 27/09/2022.
//

import UIKit

class VariantTableViewCell: UITableViewCell {
    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var nameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
