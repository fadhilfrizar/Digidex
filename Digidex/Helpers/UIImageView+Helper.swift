//
//  UIImageView+Helper.swift
//  RickAndMorty
//
//  Simple image loader (no extra pods required)
//

import UIKit

extension UIImageView {
    func loadImage(from urlString: String?) {
        self.image = UIImage(systemName: "photo")
        guard let urlString, let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self, let data, let img = UIImage(data: data) else { return }
            DispatchQueue.main.async { [weak self] in
                self?.image = img
            }
        }.resume()
    }
}
