//
//  IntroViewController.swift
//  CrossChat
//
//  Created by Mahmoud Abdurrahman on 7/10/18.
//  Copyright © 2018 Crossover. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var getStartedButton: UIButton!
    
    @IBOutlet weak var aboutCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var welcomeCenterConstraint: NSLayoutConstraint!
    
    fileprivate let introPresenter = IntroPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        introPresenter.attach(this: self)
    }
    
    deinit {
        introPresenter.detach(this: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.prepareForAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.animateScreenElementsIn()
    }
    
    func prepareForAnimation(){
        logoImage.alpha = 0
        
        let xTransform = +1*view.bounds.width
        welcomeLabel.transform = CGAffineTransform(translationX: xTransform, y: 0)
        aboutLabel.transform = CGAffineTransform(translationX: xTransform, y: 0)
        getStartedButton.transform = CGAffineTransform(translationX: xTransform, y: 0)
    }
    
    @IBAction func getStartedTapped() {
        introPresenter.onStartButtonClicked()
    }
}

extension IntroViewController: IntroView {
    
    func showNextScreen() {
        self.animateScreenElementsOut()
        self.delay(delayInSeconds: 0.4){
            self.performSegue(withIdentifier: "OpenChatScreenSegue", sender: self)
        }
    }
    
}

extension IntroViewController {
    
    func animateScreenElementsIn(){
        UIView.animate(withDuration: 0.5) { () -> Void in
            self.logoImage.alpha = 1
        }
        
        
        spring(delay: 0.2) {
            self.welcomeLabel.transform = CGAffineTransform(translationX: 0, y: 0)
        }
        
        spring(delay: 0.4) {
            self.aboutLabel.transform = CGAffineTransform(translationX: 0, y: 0)
        }
        
        
        spring(delay: 0.6) {
            self.getStartedButton.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
    
    func animateScreenElementsOut(){
        let xTransform = -1*view.bounds.width
        
        spring(delay: 0) {
            self.getStartedButton.transform = CGAffineTransform(translationX: xTransform, y: 0)
            self.logoImage.alpha = 0
        }
        
        spring(delay: 0.1) {
            self.aboutLabel.transform = CGAffineTransform(translationX: xTransform, y: 0)
        }
        
        spring(delay: 0.2){
            self.welcomeLabel.transform = CGAffineTransform(translationX: xTransform, y: 0)
        }
    }
}
