//
//  Cell.swift
//  PKCSwipeReusableView
//
//  Created by Kim Guanho on 2017. 7. 2..
//  Copyright © 2017년 CocoaPods. All rights reserved.
//

import UIKit

class Cell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.clipsToBounds = true
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
}
