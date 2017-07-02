//
//  PKCButton.swift
//  Pods
//
//  Created by Kim Guanho on 2017. 7. 2..
//
//

import UIKit

public class PKCButton: UIButton {
    public var width: CGFloat = 70
    
    func initWidth(){
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: self.width))
    }
}
