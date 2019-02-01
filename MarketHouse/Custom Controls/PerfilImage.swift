//
//  PerfilImage.swift
//  MarketHouse
//
//  Created by Arnulfo on 1/24/19.
//  Copyright © 2019 Arnulfo. All rights reserved.
//

import UIKit

class PerfilImage: UIImageView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }

}
