//
//  GFTextFiled.swift
//  TakeHomeProject
//
//  Created by ezz on 28/12/2024.
//

import UIKit

class GFTextFiled: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure(){
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius        = 10
        layer.borderWidth         = 2
        layer.borderColor         = UIColor.systemGray4.cgColor
        
        textColor                 = .label
        tintColor                 = .label
        textAlignment             = .center
        font                      =  UIFont.preferredFont(forTextStyle: .title2)
        adjustsFontSizeToFitWidth = true
        minimumFontSize           = 12
        
        returnKeyType             = .go
        backgroundColor           = .tertiarySystemBackground
        autocorrectionType        = .no
        placeholder               = "Enter a username"
    }

}

