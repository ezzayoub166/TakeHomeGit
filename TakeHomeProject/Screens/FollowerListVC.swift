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
        navigationController?.navigationBar.prefersLargeTitles = true
        NetworkManager.shared.getFollowers(for: userName!, page: 1) { result in
            switch result {
            case .success(let followers):
                print("followers Count = \(followers.count)")
                print(followers)
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Bad Stuff Happen",
                                                message: error.rawValue
                                           , buttonTitle: "Okay")
            }
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)

    }

}
