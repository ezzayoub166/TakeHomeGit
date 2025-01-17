//
//  UIHelper.swift
//  TakeHomeProject
//
//  Created by ezz on 06/01/2025.
//

import Foundation
import UIKit
struct UIHelper {
    
    static func createThreeColumnFlowLayout(in view : UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding : CGFloat        = 12
        let minimumSpacing : CGFloat = 10
        let availableWidth           = width - (padding * 2) - (minimumSpacing * 2)
        let itemWidth                = availableWidth / 3
        let flowLayout               = UICollectionViewFlowLayout()
        flowLayout.sectionInset      = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize          = CGSize(width: itemWidth, height: itemWidth + 40)
        return flowLayout
    }
}
