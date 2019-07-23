//
//  AppIconView.swift
//  MyOtherApps
//
//  Created by Dolar, Ziga on 7/23/19.
//

import UIKit

class AppIconView: UIImageView {

    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)

        guard newSuperview != nil else {
            return
        }

        layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        layer.borderWidth = 0.5
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let minSize = min(bounds.size.height, bounds.size.width)
        layer.cornerRadius = minSize / 5
        layer.masksToBounds = true
    }
}
