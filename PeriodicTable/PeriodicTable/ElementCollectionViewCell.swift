//
//  ElementCollectionViewCell.swift
//  PeriodicTable
//
//  Created by Tong Lin on 12/21/16.
//  Copyright © 2016 Tong Lin. All rights reserved.
//

import UIKit

class ElementCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var myView: ElementView!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        myView.layer.cornerRadius = 8.0
        myView.layer.masksToBounds = true
        myView.layer.borderColor = UIColor.black.cgColor
        myView.layer.borderWidth = 1.0
        
    }

}
