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
    func tableViewScrollToLasVisibleCell() {
        let lastVisibleRow = self.visibleCells.last
        let lastVisibleRowIndex = self.indexPath(for: lastVisibleRow!)
        self.scrollToRow(at: lastVisibleRowIndex!, at: .bottom, animated: true)
    }
}
