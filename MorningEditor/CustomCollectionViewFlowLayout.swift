//
//  CustomCollectionViewFlowLayout.swift
//  MorningEditor
//
//  Created by alien on 2019/4/18.
//  Copyright © 2019 z. All rights reserved.
//

import UIKit

class CustomCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attribute = layoutAttributesForItem(at: itemIndexPath)
        attribute?.alpha = 1
        return attribute
    }
    //make sure that the collectionview can get a square item size
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if newBounds.size.height != collectionView!.bounds.size.height {
            itemSize.height = newBounds.size.height
            itemSize.width = newBounds.size.height
            return true
        }
        return false
    }
}
