//
//  PagingCollectionViewProtocol.swift
//  PagingCollectionView
//
//  Created by Khater on 11/21/22.
//

import UIKit

/*
 inherit from NSObject means -> that any Object that inherit form NSObject can conform to this Protocol
*/

// MARK: - DataSource
protocol PagingCollectionViewDataSource: NSObject{
    func pagingCollectionView(_ subCollectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    func pagingCollectionView(_ subCollectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}



// MARK: - Delegate
protocol PagingCollectionViewDelegate: NSObject{
    func pagingCollectionView(_ subCollectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
}



// MARK: - Delegate Extension
extension PagingCollectionViewDelegate{
    func pagingCollectionView(_ subCollectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){}
}



// MARK: - FlowLayout
protocol PagingCollectionViewDelegateFlowLayout: PagingCollectionViewDelegate{
    func pagingCollectionView(_ subCollectionView: UICollectionView, layout subCollectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    func pagingCollectionView(_ subCollectionView: UICollectionView, layout subCollectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    func pagingCollectionView(_ subCollectionView: UICollectionView, layout subCollectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
}



// MARK: - FlowLayout Extension
extension PagingCollectionViewDelegateFlowLayout{
    func pagingCollectionView(_ subCollectionView: UICollectionView, layout subCollectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize()
    }
    
    func pagingCollectionView(_ subCollectionView: UICollectionView, layout subCollectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return CGFloat()
    }
    
    func pagingCollectionView(_ subCollectionView: UICollectionView, layout subCollectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return CGFloat()
    }
}



// MARK: - Scroll Delegate
protocol PagingCollectionViewScrollDelegate: NSObject {
    func pagingCollectionViewsDidScrollSubCollectionView(_ scrollView: UIScrollView)
    func pagingCollectionViewDidSelectSubCollectionView(at index: Int)
}

extension PagingCollectionViewScrollDelegate {
    func pagingCollectionViewsDidScrollSubCollectionView(_ scrollView: UIScrollView) {}
    func pagingCollectionViewDidSelectSubCollectionView(at index: Int) {}
}


// MARK: - Scroll Delegate For CustomSegmentControl
protocol PagingCollectionViewLinkedWithSegmentControlDelegate: CustomSegmentControl {
    func pagingCollectionViewDidScroll(for x: CGFloat)
}
