//
//  Extension.swift
//  ZahidDemo
//
//  Created by Zahid Shabbir on 27/02/2021.
//
    import Foundation
import UIKit
// MARK: - UIViewController
extension UIViewController {
    /// A generic Method instantiate a nib from class name
    /// - Returns: A View controller After initlizing nib
    static func instantiate() -> Self {
        func instantiateFromNib<T: UIViewController>(_ viewType: T.Type) -> T {
            return T.init(nibName: String(describing: T.self), bundle: nil)
        }
            return instantiateFromNib(self)
    }
}
// MARK: - UIView
extension UIView {
    func roundCorners() {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
    /// Use this function to add nice little rounded corner to your view
    /// - Parameters:
    ///   - corners: specify corners of view you want to round, `Default` is [.allCorners]
    ///   - radius: specify corner radius `Default` is 12
    func zround(corners: UIRectCorner = [.allCorners], radius: CGFloat = 12) {
        if #available(iOS 11, *) {
            self.clipsToBounds = true
            self.layer.cornerRadius = radius
            var masked = CACornerMask()
            if corners.contains(.topLeft) { masked.insert(.layerMinXMinYCorner) }
            if corners.contains(.topRight) { masked.insert(.layerMaxXMinYCorner) }
            if corners.contains(.bottomLeft) { masked.insert(.layerMinXMaxYCorner) }
            if corners.contains(.bottomRight) { masked.insert(.layerMaxXMaxYCorner) }
            self.layer.maskedCorners = masked
        } else {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    }
}
// MARK: - UIImageView
extension UIImageView {
    func download(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFill) {
            let imageCache = NSCache<NSString, UIImage>()
        let urlStringIs = url.absoluteString
            if let imageFromCache = imageCache.object(forKey: urlStringIs as NSString) {
            self.image = imageFromCache
            return
        }
            //        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async { [weak self] in
                self?.image = image
                imageCache.setObject(image, forKey: urlStringIs as NSString)
            }
        }.resume()
    }
    func download(from link: String?, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link ?? "") else {
            self.image = UIImage(named: "comingsoon")
            return
        }
            download(from: url, contentMode: mode)
    }
}
    // MARK: - UITableView
extension UITableView {
    func reloadWithAnimation() {
        self.reloadData()
        let tableViewHeight = self.bounds.size.height
        let cells = self.visibleCells
        var delayCounter = 0
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        for cell in cells {
            UIView.animate(withDuration: 1.6, delay: 0.08 * Double(delayCounter), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
    func setEmptyMessage(_ message: String, with image: UIImage?) {
        DispatchQueue.main.async {
                    let view = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
            let imageView = UIImageView(frame: CGRect(x: view.frame.width/2 - 26, y: view.frame.height/2 - 72, width: 52, height: 52))
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            let messageLabel = UILabel(frame: CGRect(x: 0, y: view.frame.height/2 + 20, width: view.bounds.width, height: view.bounds.height))
                    messageLabel.text = message
            messageLabel.textColor = .label
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = .center
            messageLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
            messageLabel.sizeToFit()
            view.contentMode = .center
            view.addSubview(messageLabel)
            view.addSubview(imageView)
                    messageLabel.translatesAutoresizingMaskIntoConstraints = false
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
            messageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
            self.backgroundView = view
        }
        }
}
    // MARK: - URLSession
extension URLSession {
    func dataTask(
        with url: URL,
        handler: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionDataTask {
        dataTask(with: url) { data, _, error in
            if let error = error {
                handler(.failure(error))
            } else {
                handler(.success(data ?? Data()))
            }
        }
    }
}

    extension UIView {
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
            animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
            self.layer.add(animation, forKey: nil)
    }
}
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
