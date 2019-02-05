//
//  UITableView+Scroll.swift
//  CrossChat
//
//  Created by Gaston  Montes on 25/01/2019.
//  Copyright © 2019 Crossover. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func tableViewScrollToLastVisibleCell() {
        let lastVisibleRow = self.visibleCells.last
        let lastVisibleRowIndex = self.indexPath(for: lastVisibleRow!)
        self.scrollToRow(at: lastVisibleRowIndex!, at: .bottom, animated: true)
    }
    
    func tableViewScrollToBottom(_ index: NSIndexPath) {
        self.scrollToRow(at: index as IndexPath, at: UITableView.ScrollPosition.bottom, animated: true)
    }
}
