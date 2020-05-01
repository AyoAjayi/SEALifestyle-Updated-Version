//
//  IngredientsCell.swift
//  Vision+ML Example
//
//  Created by Ayo  on 5/1/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class IngredientsCell: UITableViewCell {

    @IBOutlet weak var ingredientsImage: UIImageView!
    @IBOutlet weak var ingredientsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
