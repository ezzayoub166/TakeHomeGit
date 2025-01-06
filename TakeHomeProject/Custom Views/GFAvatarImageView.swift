//
//  GFAvatarImageView.swift
//  TakeHomeProject
//
//  Created by ezz on 05/01/2025.
//

import UIKit

class GFAvatarImageView: UIImageView {
    
    let placeHolderImage = UIImage(named: "avatar-placeholder")

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        layer.cornerRadius = 10 
        clipsToBounds      = true
        image              = placeHolderImage
        translatesAutoresizingMaskIntoConstraints  = false
        
    }

}
