//
//  IntroPresenter.swift
//  CrossChat
//
//  Created by Mahmoud Abdurrahman on 7/11/18.
//  Copyright © 2018 Crossover. All rights reserved.
//

import Foundation

class IntroPresenter: BasePresenter<IntroView>, IntroActions {
    
    override init() {
        super.init()
    }
    
    func onStartButtonClicked() {
        view?.showNextScreen()
    }
    
}
