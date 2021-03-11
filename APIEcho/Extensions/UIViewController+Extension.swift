//
//  UIViewController+Extension.swift
//  APIEcho
//
//  Created by Oleksandr Bardashevskyi on 09.03.2021.
//

import UIKit

extension UIViewController {
    func showAlert(with title: String, and message: String, complition: @escaping () -> Void = { }) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (_) in
            complition()
        }
        
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}
