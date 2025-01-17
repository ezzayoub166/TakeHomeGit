//
//  SearchVC.swift
//  TakeHomeProject
//
//  Created by ezz on 28/12/2024.
//

import UIKit

class SearchVC: UIViewController {
    
    let logoImageView       = UIImageView()
    let usernameTextFiled   = GFTextFiled()
    let callToActionButton  = GFButton(backgroundColor: .systemGreen, title: "Get Followers ")
    
    var isUserNameEnterd : Bool {
        return !usernameTextFiled.text!.isEmpty
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureLogoImageView()
        configureTextFiled()
        configureButton()
        createismissKeyboardTapGesture()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)

    }
    
 
    
    
    func createismissKeyboardTapGesture(){
        let tap = UITapGestureRecognizer(target: self.view
                                         , action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc func pushFollowerListVC(){
        guard isUserNameEnterd else {
            presentGFAlertOnMainThread(title: "Empty Username", message: "Please enter a username. We need to know whot to look for 😁", buttonTitle: "Ok")
            return
        }
        let followerListVC = FollowerListVC()
        followerListVC.userName = usernameTextFiled.text
        followerListVC.title = usernameTextFiled.text
       
        navigationController?.pushViewController(followerListVC, animated: true)
        
    }
    
    func configureLogoImageView(){
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image                                     = UIImage(named: "gh-logo")
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func configureTextFiled(){
        view.addSubview(usernameTextFiled)
        usernameTextFiled.delegate = self
        NSLayoutConstraint.activate([
            usernameTextFiled.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            usernameTextFiled.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            usernameTextFiled.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            usernameTextFiled.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureButton(){
        view.addSubview(callToActionButton)
        callToActionButton.addTarget(self, action: #selector(pushFollowerListVC), for: .touchUpInside)
        NSLayoutConstraint.activate([
            callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            callToActionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

}

extension SearchVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowerListVC()
        return true
    }
}
