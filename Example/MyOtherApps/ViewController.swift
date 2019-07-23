//
//  ViewController.swift
//  MyOtherApps
//
//  Created by Dolar, Ziga on 07/23/2019.
//  Copyright (c) 2019 Dolar, Ziga. All rights reserved.
//

import UIKit

import MyOtherApps

class ViewController: UIViewController {

    @IBAction func showOtherApps(_ sender: UIButton) {
        guard let appsController = AppsTableViewController.load(with: "564399117") else {
            return
        }

        appsController.delegate = self

        let navController = UINavigationController(rootViewController: appsController)
        navController.navigationBar.isTranslucent = true

        present(navController, animated: true)
    }
}

extension ViewController: AppsViewControllerDelegate {
    func appsViewController(_ viewController: UIViewController, didSelect app: App) {
        debugPrint(app.name)
    }
}
