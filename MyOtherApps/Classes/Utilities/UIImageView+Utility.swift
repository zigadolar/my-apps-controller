//
//  UIImageView.swift
//  MyOtherApps
//
//  Created by Dolar, Ziga on 7/23/19.
//

import UIKit

extension UIImageView {
    func setImage(with url: URL, placeholder image: UIImage? = nil) {
        // grab image out of cache in case needed

        self.image = image

        let session = URLSession.shared

        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)

        let task = session.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data,
                let newImage = UIImage(data: data) else {
                    return
            }

            // do some persistence here

            guard let self = self else {
                return
            }

            DispatchQueue.main.async {
                self.image = newImage
            }
        }

        task.resume()
    }
}
