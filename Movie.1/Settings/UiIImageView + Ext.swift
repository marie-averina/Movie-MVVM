//
//  UiIImageView + Ext.swift
//  Movie.1
//
//  Created by Мария Аверина on 27.07.2022.
//

import UIKit
import Alamofire

extension UIImageView {
    func load(data: Data) {
        DispatchQueue.global().async { [weak self] in
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
}
