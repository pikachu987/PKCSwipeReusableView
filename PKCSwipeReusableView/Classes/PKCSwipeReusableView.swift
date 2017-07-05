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
    
    private var pkcContainerImageView: PKCContainerImageView?
    private var rightArray = [PKCButton]()
    private var leftArray = [PKCButton]()
    private var rightWidth : CGFloat = 0
    private var leftWidth : CGFloat = 0
    
    private var panGesture: PKCPanGestureRecognizer?
    
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
        if self.pkcContainerImageView == nil{
            self.initSwipe()
        }
        self.addSubview(pkcButton)
        pkcButton.initWidth()
    }
    
    public func addRightSwipe(_ pkcButton: PKCButton){
        self.addSwipe(pkcButton)
        pkcButton.rightConstApply(self.rightArray.isEmpty ? self.pkcContainerImageView : self.rightArray.last)
        self.pkcContainerImageView?.rightThanConst(pkcButton)
        self.rightArray.append(pkcButton)
        self.rightWidth += pkcButton.width
    }
    
    public func addLeftSwipe(_ pkcButton: PKCButton){
        self.addSwipe(pkcButton)
        pkcButton.leftConstApply(self.leftArray.isEmpty ? self.pkcContainerImageView : self.leftArray.last)
        self.pkcContainerImageView?.leftThanConst(pkcButton)
        self.leftArray.append(pkcButton)
        self.leftWidth += pkcButton.width
    }
    
    
    
    public func hide(_ animation: Bool){
        self.pkcContainerImageView?.leadingConstant(0, animation: animation)
    }
    public func showLeft(_ animation: Bool){
        self.pkcContainerImageView?.leadingConstant(-self.leftWidth, animation: animation)
    }
    public func showRight(_ animation: Bool){
        self.pkcContainerImageView?.leadingConstant(self.rightWidth, animation: animation)
    }
    
    private func removeSwipe(){
        self.pkcContainerImageView?.remove()
        self.rightArray.forEach({ $0.removeFromSuperview() })
        self.leftArray.forEach({ $0.removeFromSuperview() })
        self.rightArray = [PKCButton]()
        self.leftArray = [PKCButton]()
        self.rightWidth = 0
        self.leftWidth = 0
        self.removeGesture()
    }
    
    private func initSwipe(){
        let pkcContainerView = PKCContainerImageView(self.bounds.width)
        self.addSubview(pkcContainerView)
        pkcContainerView.constApply()
        self.pkcContainerImageView = pkcContainerView
        
        self.removeGesture()
        let panGesture = PKCPanGestureRecognizer(target: self, action: #selector(self.panAction(_:)))
        self.addGestureRecognizer(panGesture)
        self.panGesture = panGesture
    }
    
    private func removeGesture(){
        guard let panGesture = self.panGesture else{
            return
        }
        self.removeGestureRecognizer(panGesture)
        self.panGesture = nil
    }
    
    
    @objc private func panAction(_ sender: PKCPanGestureRecognizer){
        guard let leading = self.pkcContainerImageView?.leadingConst else {
            return
        }
        let velocity = sender.velocity(in: self)
        let value = leading.constant - velocity.x/100
        
        if value < -self.leftWidth{
            leading.constant = -self.leftWidth
            return
        }
        
        if value > self.rightWidth{
            leading.constant = self.rightWidth
            return
        }
        
        leading.constant = value
        
        if sender.state == .began{ self.moveType = velocity.x > 0 ? .left : .right }
        
        if sender.state == .ended{
            if value > 0 {
                var widthBoundary = self.rightWidth
                if self.moveType == .left{
                    widthBoundary = widthBoundary/3*2
                }else if self.moveType == .right{
                    widthBoundary = widthBoundary/3
                }
                leading.constant = (widthBoundary > value) ? 0 : self.rightWidth
            }else{
                var widthBoundary = -self.leftWidth
                if self.moveType == .left{
                    widthBoundary = widthBoundary/3
                }else if self.moveType == .right{
                    widthBoundary = widthBoundary/3*2
                }
                leading.constant = (widthBoundary < value) ? 0 : -self.leftWidth
            }
            
            UIView.animate(withDuration: PKCSwipeHelper.shared.gestureTimeInterval, animations: {
                self.layoutIfNeeded()
            })
            self.moveType = .default
        }
    }
}


