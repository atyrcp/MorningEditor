//
//  ImageCollectionViewCell.swift
//  MorningEditor
//
//  Created by alien on 2019/4/8.
//  Copyright © 2019 z. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    func displayView(using image: UIImage) {
        self.imageView.image = image
    }
    
    func setupViews() {
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
}
