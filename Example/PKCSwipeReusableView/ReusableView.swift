//
//  ReusableView.swift
//  PKCSwipeReusableView
//
//  Created by Kim Guanho on 2017. 7. 2..
//  Copyright © 2017년 CocoaPods. All rights reserved.
//

import UIKit
import PKCSwipeReusableView

class ReusableView: PKCSwipeReusableView {
    private var containerView: UIView!
    @IBOutlet weak var label: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInitialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInitialization()
    }
    
    
    
    private func commonInitialization(){
        self.containerView = Bundle.main.loadNibNamed("ReusableView", owner: self, options: nil)?.first as! UIView
        self.containerView.frame = self.bounds
        
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.containerView)
        let view_constraint_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.containerView])
        let view_constraint_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutFormatOptions.alignAllLeading, metrics: nil, views: ["view": self.containerView])
        self.addConstraints(view_constraint_H)
        self.addConstraints(view_constraint_V)
        
        self.initVars()
    }
    
    
    
    
    private func initVars(){
        self.containerView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        self.backgroundColor = UIColor.clear
    }
    
    
    
    
    
    func setEntity(_ indexPath: IndexPath){
        self.label.text = "header : \(indexPath.section),\(indexPath.row)"
        let pkcButton = PKCButton(frame: .zero)
        pkcButton.backgroundColor = .red
        self.addRightSwipe(pkcButton)
        if indexPath.section == 0{
            let pkc2 = PKCButton(frame: .zero)
            pkc2.backgroundColor = .green
            self.addLeftSwipe(pkc2)
        }
    }
}
