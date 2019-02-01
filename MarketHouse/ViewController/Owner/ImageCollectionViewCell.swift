//
//  ImageCollectionViewCell.swift
//  MarketHouse
//
//  Created by Arnulfo on 1/28/19.
//  Copyright © 2019 Arnulfo. All rights reserved.
//

import UIKit

protocol dataCollectionProtocol {
    func deleteImage(index: Int)
}

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    
    var delegate: dataCollectionProtocol?
    var index : IndexPath?
    
    @IBAction func deleteImage(_ sender: UIButton) {
        delegate?.deleteImage(index: (index?.row)!)
    }
}
