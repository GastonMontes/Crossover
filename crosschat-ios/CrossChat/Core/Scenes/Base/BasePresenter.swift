//
//  BasePresenter.swift
//  CrossChat
//
//  Created by Mahmoud Abdurrahman on 7/11/18.
//  Copyright © 2018 Crossover. All rights reserved.
//

import Foundation

class BasePresenter<View> {
    
    var firstLaunch = true
    var view: View?
    
    init() {
    }
    
    func attach(this view: View) {
        self.view = view
        
        if (firstLaunch) {
            firstLaunch = false
            onFirstViewAttach()
        }
    }
    
    func detach(this view: View) {
        self.view = nil
    }
    
    func onFirstViewAttach() {
        
    }
    
}
