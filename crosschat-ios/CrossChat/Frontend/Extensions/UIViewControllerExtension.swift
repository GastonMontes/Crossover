//
//  UIViewControllerExtension.swift
//  CrossChat
//
//  Created by Mahmoud Abdurrahman on 7/10/18.
//  Copyright © 2018 Crossover. All rights reserved.
//

import UIKit

struct AssociatedKeys {
    static var workItem: DispatchWorkItem? = nil
}

extension UIViewController {
    
    private(set) var workItem: DispatchWorkItem? {
        get {
            guard let value = objc_getAssociatedObject(self, &AssociatedKeys.workItem) as? DispatchWorkItem else {
                return nil
            }
            return value
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.workItem, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func spring(delay: TimeInterval, animations: @escaping ()->Void, completion: ((_ finished: Bool) -> Void)?) {
        UIView.animate(withDuration: 0.8, delay: delay, usingSpringWithDamping: 0.6, initialSpringVelocity: 5, options: .curveEaseInOut, animations: animations, completion: completion)
    }
    
    func spring(delay: TimeInterval, animations: @escaping ()->Void) {
        spring(delay: delay, animations: animations, completion: nil)
    }
    
    func delay(delayInSeconds: Double, closure:@escaping ()->()) {
        let queue = DispatchQueue.main
        let deadline = DispatchTime.now() + .seconds(Int(delayInSeconds))
        
        if (workItem != nil) {
            workItem?.cancel()
            workItem = nil
        }
        
        workItem = DispatchWorkItem{ [weak self] in
            closure()
            self?.workItem = nil
        }
        
        guard let workItem = workItem else {
            return
        }
        
        queue.asyncAfter(deadline: deadline, execute: workItem)
    }
}
