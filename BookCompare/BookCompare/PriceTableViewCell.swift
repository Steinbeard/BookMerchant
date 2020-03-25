//
//  PriceTableViewCell.swift
//  BookCompare
//
//  Created by Daniel Steinberg on 3/24/20.
//  Copyright © 2020 Daniel Steinberg. All rights reserved.
//

import UIKit

class PriceTableViewCell: UITableViewCell {
    @IBOutlet var sellerLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var conditionLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
