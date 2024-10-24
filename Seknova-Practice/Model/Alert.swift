//
//  Alert.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2024/10/24.
//

import Foundation
import UIKit

class Alert {
    func showActionSheet(titles: [String],
                        cancelTitle: String,
                        vc: UIViewController,
                         action: @escaping (String) -> Void) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.view.tintColor = UIColor.mainColor
        
        for title in titles {
            let action = UIAlertAction(title: title, style: .default) { _ in
                action(title)
            }
            alert.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title: String,
                   message: String,
                   vc: UIViewController,
                   action: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "確定", style: .default) { _ in
            action()
        }
        alert.addAction(okAction)
        
        vc.present(alert, animated: true, completion: nil)
    }
}
