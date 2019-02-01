//
//  PublicationsViewCell.swift
//  MarketHouse
//
//  Created by Arnulfo on 1/30/19.
//  Copyright © 2019 Arnulfo. All rights reserved.
//

import UIKit

class PublicationsViewCell: UITableViewCell {
    
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var titleCell: UILabel!
    @IBOutlet weak var descriptionCell: UILabel!
    var idPublicationCell: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
