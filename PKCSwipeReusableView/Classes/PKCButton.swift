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

public class PKCButton: UIButton {
    public var width: CGFloat = PKCSwipeHelper.shared.buttonWidth
    
    private var handler: ((PKCButton) -> Void)? = nil
    
    func initWidth(){
        guard let superView = self.superview else {
            return
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(
            item: self,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .width,
            multiplier: 1,
            constant: self.width))
        
        superView.addConstraints(self.verticalLayout())
        
        self.removeTarget(self, action: #selector(self.action(_:)), for: .touchUpInside)
        self.addTarget(self, action: #selector(self.action(_:)), for: .touchUpInside)
    }
    
    func rightConstApply(_ toItem: UIView?){
        guard let superView = self.superview as? PKCSwipeReusableView else {
            return
        }
        let const = NSLayoutConstraint(
            item: self,
            attribute: .left,
            relatedBy: .equal,
            toItem: toItem,
            attribute: .right,
            multiplier: 1,
            constant: 0)
        superView.addConstraint(const)
    }
    
    func leftConstApply(_ toItem: UIView?){
        guard let superView = self.superview as? PKCSwipeReusableView else {
            return
        }
        let const = NSLayoutConstraint(
            item: self,
            attribute: .right,
            relatedBy: .equal,
            toItem: toItem,
            attribute: .left,
            multiplier: 1,
            constant: 0)
        superView.addConstraint(const)
    }
    
    public func addTarget(_ handler: @escaping (PKCButton) -> Void){
        self.handler = handler
    }
    
    @objc private func action(_ sender: PKCButton){
        if PKCSwipeHelper.shared.touchAfterHide{
            if let superView = self.superview as? PKCSwipeReusableView {
                superView.hide(true)
            }
        }
        self.handler?(sender)
    }
}
