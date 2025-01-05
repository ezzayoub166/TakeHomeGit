//
//  FollowerListVC.swift
//  TakeHomeProject
//
//  Created by ezz on 29/12/2024.
//

import UIKit

class FollowerListVC: UIViewController {
    
    
    var userName : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true

    }

}
