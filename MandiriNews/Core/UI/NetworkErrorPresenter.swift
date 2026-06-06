//
//  NetworkErrorPresenter.swift
//  MandiriNews
//
//  Created by Rifky Radityatama on 04/06/26.
//

import UIKit

enum NetworkErrorPresenter {

    static func present(
        on viewController: UIViewController,
        error: NetworkError,
        onRetry: (() -> Void)?,
        onShowVisualState: @escaping (_ iconName: String, _ message: String) -> Void
    ) {
        switch error {
        case .invalidURL:
            let message = "A system error occurred. Please try again later."
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in
                onRetry?()
            }))

            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                onShowVisualState("exclamationmark.triangle", message)
            }))

            viewController.present(alert, animated: true)

        case .noData:
            let message = "No data available at the moment."
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                onShowVisualState("tray", message)
            }))

            viewController.present(alert, animated: true)
        }
    }
}
