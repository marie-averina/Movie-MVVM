//
//  UIViewController + Ext.swift
//  Movie.1
//
//  Created by Мария Аверина on 24.09.2022.
//

import UIKit

extension UIViewController {
    func showError(_ error: Error) {
        let alertVC = UIAlertController(title: "Error",
                                        message: error.localizedDescription,
                                        preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title,
                                        message: message,
                                        preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
}

