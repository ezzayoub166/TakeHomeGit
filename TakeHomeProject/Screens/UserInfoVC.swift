//
//  UserInfoVC.swift
//  TakeHomeProject
//
//  Created by ezz on 08/01/2025.
//

import UIKit

class UserInfoVC: UIViewController {
    
    var username : String!
    
    let headerView           = UIView()
    let itemViewOne          = UIView()
    let itemViewTow          = UIView()
    
    var itemViews : [UIView] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        layoutUI()
        getUserInfo()
   
 
    }
    
    func configureViewController(){
        view.backgroundColor              = .systemBackground
        let doneButton                    = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    
    func getUserInfo(){
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
    }
    
    
    func layoutUI(){
        let padding    : CGFloat    = 20
        let itemHeight : CGFloat    = 140
        
 
        itemViews = [headerView , itemViewOne , itemViewTow]
        for subView in itemViews {
            view.addSubview(subView)
            subView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                subView.leadingAnchor.constraint(equalTo: view.leadingAnchor , constant: padding),
                subView.trailingAnchor.constraint(equalTo: view.trailingAnchor , constant: -padding),
            ])
        }
        
        itemViewOne.backgroundColor = .systemBlue
        itemViewTow.backgroundColor = .systemPink
                
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTow.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTow.heightAnchor.constraint(equalToConstant: itemHeight)
        
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
