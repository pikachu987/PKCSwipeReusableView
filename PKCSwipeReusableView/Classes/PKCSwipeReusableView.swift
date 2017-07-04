//Copyright (c) 2017 pikachu987 <pikachu77769@gmail.com>
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.


import UIKit

open class PKCSwipeReusableView: UICollectionReusableView{
    enum MoveType {
        case left, right, `default`
    }
    
    private var rightArray = [PKCButton]()
    private var leftArray = [PKCButton]()
    
    private var containerView: UIView?
    private var containerLeadingConst: NSLayoutConstraint?
    
    private var rightWidth : CGFloat = 0
    private var leftWidth : CGFloat = 0
    
    private var rightConst: NSLayoutConstraint?
    private var leftConst: NSLayoutConstraint?
    
    private var moveType: MoveType = .default
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.removeSwipe()
        self.initSwipe()
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        self.removeSwipe()
        self.initSwipe()
    }
    
    
    private func addSwipe(_ pkcButton: PKCButton){
        if self.containerView == nil{
            self.initSwipe()
        }
        self.addSubview(pkcButton)
        pkcButton.initWidth()
        self.addConstraints(pkcButton.verticalLayout())
    }
    
    public func addRightSwipe(_ pkcButton: PKCButton){
        self.addSwipe(pkcButton)
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
        self.addSwipe(pkcButton)
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
    
    
    public func hide(_ animation: Bool){
        self.containerLeadingConst?.constant = 0
        if animation{
            UIView.animate(withDuration: PKCSwipeHelper.shared.hideTimeInterval, animations: {
                self.layoutIfNeeded()
            })
        }
    }
    public func showLeft(_ animation: Bool){
        self.containerLeadingConst?.constant = -self.leftWidth
        if animation{
            UIView.animate(withDuration: PKCSwipeHelper.shared.showTimeInterval, animations: {
                self.layoutIfNeeded()
            })
        }
    }
    
    public func showRight(_ animation: Bool){
        self.containerLeadingConst?.constant = self.rightWidth
        if animation{
            UIView.animate(withDuration: PKCSwipeHelper.shared.showTimeInterval, animations: {
                self.layoutIfNeeded()
            })
        }
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
            self.containerLeadingConst?.constant = -self.leftWidth
            return
        }
        if value > self.rightWidth{
            self.containerLeadingConst?.constant = self.rightWidth
            return
        }
        self.containerLeadingConst?.constant = value
        if sender.state == .began{
            self.moveType = velocity.x > 0 ? .left : .right
        }
        if sender.state == .ended{
            if value > 0 {
                var widthBoundary = self.rightWidth
                if self.moveType == .left{
                    widthBoundary = widthBoundary/3*2
                }else if self.moveType == .right{
                    widthBoundary = widthBoundary/3
                }
                self.containerLeadingConst?.constant = (widthBoundary > value) ? 0 : self.rightWidth
            }else{
                var widthBoundary = -self.leftWidth
                if self.moveType == .left{
                    widthBoundary = widthBoundary/3
                }else if self.moveType == .right{
                    widthBoundary = widthBoundary/3*2
                }
                self.containerLeadingConst?.constant = (widthBoundary < value) ? 0 : -self.leftWidth
            }
            
            UIView.animate(withDuration: PKCSwipeHelper.shared.gestureTimeInterval, animations: {
                self.layoutIfNeeded()
            })
            self.moveType = .default
        }
    }
}

extension PKCSwipeReusableView: UIGestureRecognizerDelegate{
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
