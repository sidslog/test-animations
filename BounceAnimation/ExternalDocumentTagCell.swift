//
//  ExternalDocumentTagCell.swift
//  Boardmaps
//
//  Created by Sergey Sedov on 5/8/15.
//  Copyright (c) 2015 Dashboard Systems. All rights reserved.
//

import UIKit

class ExternalDocumentTagCell: UICollectionViewCell {

    @IBOutlet weak var back: UIView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.back.layer.cornerRadius = 5;
        self.back.layer.masksToBounds = true;
        self.back.backgroundColor = UIColor.grayColor();
        self.label.textColor = UIColor.blackColor();
    }
    
    
    func configure(tag: String) {
        self.label.text = tag;
    }

    func size() -> CGSize {
        self.layoutIfNeeded();
        let size = self.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize);
        return size;
    }
}
