//
//  HeaderCell.swift
//  BounceAnimation
//
//  Created by Sergey Sedov on 26/08/15.
//  Copyright (c) 2015 Sergey Sedov. All rights reserved.
//

import UIKit

class TagSearchHeaderCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func size() -> CGSize {
        self.layoutIfNeeded();
        let size = self.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize);
        return size;
    }


}
