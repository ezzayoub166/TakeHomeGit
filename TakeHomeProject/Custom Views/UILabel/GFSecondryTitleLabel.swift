//
//  GFSecondryTitleLabel.swift
//  TakeHomeProject
//
//  Created by ezz on 09/01/2025.
//

import UIKit

class GFSecondryTitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(fontSize : CGFloat ) {
        super.init(frame: .zero)
        self.font = .systemFont(ofSize: fontSize , weight: .medium)
        configure()
    }
    
    private func configure(){
        textColor = .secondaryLabel
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.90
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
        
    }

}
