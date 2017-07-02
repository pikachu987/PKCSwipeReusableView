//
//  ViewController.swift
//  PKCSwipeReusableView
//
//  Created by pikachu987 on 07/02/2017.
//  Copyright (c) 2017 pikachu987. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(UINib(nibName: "Cell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        self.collectionView.register(ReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ReusableView")
        self.collectionView.register(ReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "ReusableView")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.collectionViewLayout = .layout()
    }
}

extension ViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("touch: \(indexPath)")
    }
}

extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        cell.imageView.image = UIImage(named: "\(indexPath.row+1).jpg")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader{
            let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ReusableView", for: indexPath) as! ReusableView
            reusableView.setEntity(indexPath)
            return reusableView
        }else if kind == UICollectionElementKindSectionFooter{
            let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ReusableView", for: indexPath) as! ReusableView
            reusableView.setEntity(indexPath)
            return reusableView
        }else{
            assert(false, "Unexpected element kind")
        }
    }
}


extension ViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 0)
    }
}


extension UICollectionViewLayout{
    static func layout() -> UICollectionViewLayout{
        let flow = UICollectionViewFlowLayout()
        flow.itemSize = CGSize(width: UIScreen.main.bounds.width/4, height: UIScreen.main.bounds.width/4)
        flow.minimumInteritemSpacing = 0
        flow.minimumLineSpacing = 0
        return flow
    }
}
