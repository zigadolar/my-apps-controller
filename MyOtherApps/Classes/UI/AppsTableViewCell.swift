//
//  AppsTableViewCell.swift
//  MyOtherApps
//
//  Created by Dolar, Ziga on 7/23/19.
//

import UIKit

class AppsTableViewCell: UITableViewCell {

    @IBOutlet private(set) var appIcon: UIImageView!
    @IBOutlet private(set) var appName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with app: App) {
        appIcon.setImage(with: app.iconURL, placeholder: nil)
        appName.text = app.name
    }
}
