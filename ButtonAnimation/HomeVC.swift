//
//  HomeVC.swift
//  ButtonAnimation
//
//  Created by Shuvo on 8/16/17.
//  Copyright © 2017 Shuvo. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak private var loginBtn: LoadingButton!
    @IBOutlet weak var signupBtn: LoadingButton!
    @IBOutlet weak var signupBtnHeightConstraint: NSLayoutConstraint!
    
    
    private var isSelected = false
    private let circleTransitionNavDelegate = CircleTransitionNavDelegate()
    private let circleTransitionDelegate = CircleTransitonDelegate()
    private var signupBtnInitialHeight: CGFloat = 0
    private let newHeight: CGFloat = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signupBtn.spinnerColor = UIColor.black
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        signupBtnInitialHeight = signupBtnHeightConstraint.constant
    }
    
    @IBAction func loginAction(_ sender: LoadingButton) {
        
//        if isSelected {
//            sender.stopAnimation()
//        } else {
//            sender.startAnimation()
//        }
//        isSelected = !isSelected
        
        animateAndTransit()
    }
    
    @IBAction func signupAction(_ sender: LoadingButton) {
        
        if isSelected {
            sender.stopAnimation()
            signupBtnHeightConstraint.constant = signupBtnInitialHeight
            sender.layoutIfNeeded()
        } else {
            signupBtnHeightConstraint.constant = newHeight
            sender.layoutIfNeeded()
            sender.startAnimation()
        }
        isSelected = !isSelected
        
        //signupAnimateAndTransit()
    }
    
    private func animateAndTransit() {
        loginBtn.startAnimation()
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        
        Timer.schedule(delay: 1) { (timer) in
            // circle modal present
            self.circleTransitionDelegate.originView = self.loginBtn
            vc.transitioningDelegate = self.circleTransitionDelegate
            vc.shouldShowDismissLbl = true
            self.present(vc, animated: true, completion: { 
                self.loginBtn.stopAnimation()
            })
        }
    }
    
    private func signupAnimateAndTransit() {
        signupBtnHeightConstraint.constant = newHeight
        signupBtn.layoutIfNeeded()
        
        signupBtn.startAnimation()
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        
        Timer.schedule(delay: 1) { (timer) in
            // circle modal present
            self.circleTransitionDelegate.originView = self.signupBtn
            vc.transitioningDelegate = self.circleTransitionDelegate
            vc.shouldShowDismissLbl = true
            self.present(vc, animated: true, completion: {
                self.signupBtn.stopAnimation()
                self.signupBtnHeightConstraint.constant = self.signupBtnInitialHeight
                self.signupBtn.layoutIfNeeded()
            })
        }
    }
    


}
