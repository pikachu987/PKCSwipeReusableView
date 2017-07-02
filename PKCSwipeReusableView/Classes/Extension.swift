//
//  Extension.swift
//  Pods
//
//  Created by Kim Guanho on 2017. 7. 2..
//
//

import UIKit

extension UIView{
    func horizontalLayout(left: CGFloat = 0, right: CGFloat = 0) -> [NSLayoutConstraint]{
        return NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(left)-[view]-\(right)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self])
    }
    func verticalLayout(top: CGFloat = 0, bottom: CGFloat = 0) -> [NSLayoutConstraint]{
        return NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(top)-[view]-\(bottom)-|", options: NSLayoutFormatOptions.alignAllLeading, metrics: nil, views: ["view": self])
    }
}

extension UIView {
    func imageWithView() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}
