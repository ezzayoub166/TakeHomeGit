//
//  UserInfoVC.swift
//  TakeHomeProject
//
//  Created by ezz on 08/01/2025.
//

import UIKit

class UserInfoVC: UIViewController {
    
    var username : String!
    
    let headerView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            
            guard let self = self else {return}
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.add(childVC: GFUserInforHeaderVC(user: user), to: self.headerView)

                }
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Some thing Wrong", message: error.rawValue, buttonTitle: "Okay")
                print(error)
            }
        }
        layoutUI()
    }
    
    
    func configureViewController(){
        view.backgroundColor              = .systemBackground
        let doneButton                    = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
        
    }
    
    func layoutUI(){
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180)
            
        
        
        ])
    }
    
    func add(childVC : UIViewController , to containerView : UIView){
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    @objc private func dismissVC(){
        dismiss(animated: true)
    }

    

}
