//
//  UITableView + Ext.swift
//  Movie.1
//
//  Created by Мария Аверина on 15.09.2022.
//

import UIKit

extension UITableView {
    
    func setUpRefreshControl(selector: Selector) {
        let refreshControl = UIRefreshControl()
        self.refreshControl = refreshControl
        self.refreshControl?.addTarget(self, action: selector, for: .valueChanged)
    }
    
}
