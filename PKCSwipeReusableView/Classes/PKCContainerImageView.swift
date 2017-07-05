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

class PKCContainerImageView: UIImageView {
    var widthConst: NSLayoutConstraint?
    var leadingConst: NSLayoutConstraint?
    
    var rightThanConst: NSLayoutConstraint?
    var leftThanConst: NSLayoutConstraint?
    
    init(_ width: CGFloat) {
        super.init(frame: .zero)
        self.isUserInteractionEnabled = false
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        
        let widthConst = NSLayoutConstraint(
            item: self,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .width,
            multiplier: 1,
            constant: width)
        self.addConstraint(widthConst)
        self.widthConst = widthConst
    }
    
    func constApply(){
        guard let superView = self.superview else {
            return
        }
        superView.addConstraints(self.verticalLayout())
        
        let leadingConst = NSLayoutConstraint(
            item: superView,
            attribute: .leading,
            relatedBy: .equal,
            toItem: self,
            attribute: .leading,
            multiplier: 1,
            constant: 0)
        leadingConst.priority = UILayoutPriority(999)
        superView.addConstraint(leadingConst)
        self.leadingConst = leadingConst
        
        self.rightThanConst(self)
        self.leftThanConst(self)
        
        DispatchQueue.main.async {
            self.widthConst?.constant = superView.bounds.width
            if !PKCSwipeHelper.shared.overlay{
                if let image = superView.imageWithView(){
                    self.image = image
                }
            }
        }
    }
    
    
    func rightThanConst(_ view: UIView){
        guard let superView = self.superview else {
            return
        }
        self.rightThanConst?.isActive = false
        let rightThanConst = NSLayoutConstraint(
            item: superView,
            attribute: .trailing,
            relatedBy: .lessThanOrEqual,
            toItem: view,
            attribute: .trailing,
            multiplier: 1,
            constant: 0)
        superView.addConstraint(rightThanConst)
        self.rightThanConst = rightThanConst
    }
    
    func leftThanConst(_ view: UIView){
        guard let superView = self.superview else {
            return
        }
        self.leftThanConst?.isActive = false
        let leftThanConst = NSLayoutConstraint(
            item: superView,
            attribute: .leading,
            relatedBy: .greaterThanOrEqual,
            toItem: view,
            attribute: .leading,
            multiplier: 1,
            constant: 0)
        superView.addConstraint(leftThanConst)
        self.leftThanConst = leftThanConst
    }
    
    
    func leadingConstant(_ constant: CGFloat, animation: Bool){
        guard let superView = self.superview else {
            return
        }
        self.leadingConst?.constant = constant
        if animation{
            UIView.animate(withDuration: PKCSwipeHelper.shared.hideTimeInterval, animations: {
                superView.layoutIfNeeded()
            })
        }
    }
    
    func remove(){
        self.leadingConst?.constant = 0
        self.leadingConst?.isActive = false
        self.rightThanConst?.isActive = false
        self.leftThanConst?.isActive = false
        self.removeFromSuperview()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
