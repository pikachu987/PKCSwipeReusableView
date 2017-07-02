//
//  PKCSwipeReusableView.swift
//  Pods
//
//  Created by Kim Guanho on 2017. 7. 2..
//
//

import UIKit

open class PKCSwipeReusableView: UICollectionReusableView{
    private var rightArray = [PKCButton]()
    private var leftArray = [PKCButton]()
    
    private var containerView: UIView?
    private var containerLeadingConst: NSLayoutConstraint?
    
    private var rightWidth : CGFloat = 0
    private var leftWidth : CGFloat = 0
    
    private var rightConst: NSLayoutConstraint?
    private var leftConst: NSLayoutConstraint?
    
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.removeSwipe()
        self.initSwipe()
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        self.containerLeadingConst?.constant = 0
    }
    
    public func addRightSwipe(_ pkcButton: PKCButton){
        if containerView == nil{
            self.initSwipe()
        }
        self.addSubview(pkcButton)
        pkcButton.initWidth()
        self.addConstraints(pkcButton.verticalLayout())
        if self.rightArray.isEmpty{
            let const = NSLayoutConstraint(
                item: pkcButton,
                attribute: .left,
                relatedBy: .equal,
                toItem: self.containerView,
                attribute: .right,
                multiplier: 1,
                constant: 0)
            self.addConstraint(const)
        }else{
            let const = NSLayoutConstraint(
                item: pkcButton,
                attribute: .left,
                relatedBy: .equal,
                toItem: self.rightArray.last,
                attribute: .right,
                multiplier: 1,
                constant: 0)
            self.addConstraint(const)
        }
        self.rightConst?.isActive = false
        let rightConst = NSLayoutConstraint(
            item: self,
            attribute: .trailing,
            relatedBy: .lessThanOrEqual,
            toItem: pkcButton,
            attribute: .trailing,
            multiplier: 1,
            constant: 0)
        self.addConstraint(rightConst)
        self.rightConst = rightConst
        
        self.rightArray.append(pkcButton)
        self.rightWidth += pkcButton.width
    }
    
    public func addLeftSwipe(_ pkcButton: PKCButton){
        if containerView == nil{
            self.initSwipe()
        }
        self.addSubview(pkcButton)
        pkcButton.initWidth()
        self.addConstraints(pkcButton.verticalLayout())
        if self.leftArray.isEmpty{
            let const = NSLayoutConstraint(
                item: pkcButton,
                attribute: .right,
                relatedBy: .equal,
                toItem: self.containerView,
                attribute: .left,
                multiplier: 1,
                constant: 0)
            self.addConstraint(const)
        }else{
            let const = NSLayoutConstraint(
                item: pkcButton,
                attribute: .right,
                relatedBy: .equal,
                toItem: self.leftArray.last,
                attribute: .left,
                multiplier: 1,
                constant: 0)
            self.addConstraint(const)
        }
        self.leftConst?.isActive = false
        let leftConst = NSLayoutConstraint(
            item: self,
            attribute: .leading,
            relatedBy: .greaterThanOrEqual,
            toItem: pkcButton,
            attribute: .leading,
            multiplier: 1,
            constant: 0)
        self.addConstraint(leftConst)
        self.leftConst = leftConst
        
        self.leftArray.append(pkcButton)
        self.leftWidth += pkcButton.width
    }
    
    
    private func removeSwipe(){
        self.containerLeadingConst?.constant = 0
        self.containerLeadingConst?.isActive = false
        self.containerView?.removeFromSuperview()
        self.rightConst?.isActive = false
        self.leftConst?.isActive = false
        self.rightArray.forEach({ $0.removeFromSuperview() })
        self.leftArray.forEach({ $0.removeFromSuperview() })
        self.rightArray = [PKCButton]()
        self.leftArray = [PKCButton]()
        self.rightWidth = 0
        self.leftWidth = 0
    }
    
    private func initSwipe(){
        let containerView = UIImageView(frame: .zero)
        
        containerView.isUserInteractionEnabled = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .clear
        
        self.addSubview(containerView)
        self.addConstraints(containerView.verticalLayout())
        let widthConst = NSLayoutConstraint(
            item: containerView,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .width,
            multiplier: 1,
            constant: self.bounds.width)
        self.addConstraint(widthConst)
        let containerLeadingConst = NSLayoutConstraint(
            item: self,
            attribute: .leading,
            relatedBy: .equal,
            toItem: containerView,
            attribute: .leading,
            multiplier: 1,
            constant: 0)
        containerLeadingConst.priority = UILayoutPriority(999)
        self.addConstraint(containerLeadingConst)
        DispatchQueue.main.async {
            widthConst.constant = self.bounds.width
            if let image = self.imageWithView(){
                containerView.image = image
            }
        }
        self.containerView = containerView
        self.containerLeadingConst = containerLeadingConst
        
        let rightConst = NSLayoutConstraint(
            item: self,
            attribute: .right,
            relatedBy: .lessThanOrEqual,
            toItem: self.containerView,
            attribute: .right,
            multiplier: 1,
            constant: 0)
        self.addConstraint(rightConst)
        self.rightConst = rightConst
        
        let leftConst = NSLayoutConstraint(
            item: self,
            attribute: .leading,
            relatedBy: .greaterThanOrEqual,
            toItem: self.containerView,
            attribute: .leading,
            multiplier: 1,
            constant: 0)
        self.addConstraint(leftConst)
        self.leftConst = leftConst
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panAction(_:)))
        panGesture.delegate = self
        self.addGestureRecognizer(panGesture)
    }
    
    @objc private func panAction(_ sender: UIPanGestureRecognizer){
        guard let leading = self.containerLeadingConst else {
            return
        }
        
        let velocity = sender.velocity(in: self)
        let value = leading.constant - velocity.x/100
        if value < -self.leftWidth{
            return
        }
        if value > self.rightWidth{
            return
        }
        self.containerLeadingConst?.constant = value
    }
}

extension PKCSwipeReusableView: UIGestureRecognizerDelegate{
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
