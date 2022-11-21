//
//  PagingCollectionView.swift
//  PagingCollectionView
//
//  Created by Khater on 11/21/22.
//

import UIKit

final class PagingCollectionView: UICollectionView{
    
    weak var pagingDataSource: PagingCollectionViewDataSource?
    
    private weak var pagingDelegateFlowLayout: PagingCollectionViewDelegateFlowLayout?
    
    weak var pagingDelegate: PagingCollectionViewDelegate? {
        didSet{
            pagingDelegateFlowLayout = pagingDelegate as? PagingCollectionViewDelegateFlowLayout
        }
    }

    weak var scrollDelegate: PagingCollectionViewScrollDelegate?
    
    // ScrollWithSegmentDelegate and SegmentControl they link PagingCollectionView class and CustomeSegmentControl class with each other
    private weak var scrollWithSegmentDelegate: PagingCollectionViewLinkedWithSegmentControlDelegate?
    weak var segmentControl: CustomSegmentControl? {
        didSet{
            if let segmentControl = segmentControl {
                // Set delegate of Custom Segment Control
                segmentControl.delegate = self
                // Set delegate of Collection View Scrollingb
                scrollWithSegmentDelegate = segmentControl
            }
        }
    }
    
    private var subCollectionViews: [UICollectionView] = []
    
    private let pagingCollecitionViewCellIdenifire = "PagingCollectionViewCell"
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupPagingCollectionView()
    }
    
    deinit {
        print("PagingCollectionView deinit")
    }
    
    private func setupPagingCollectionView(){
        register(UICollectionViewCell.self, forCellWithReuseIdentifier: pagingCollecitionViewCellIdenifire)
        delegate = self
        dataSource = self
        isPagingEnabled = true
        showsHorizontalScrollIndicator = false
        
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout{
            flowLayout.scrollDirection = .horizontal
        }
    }
    
    public func addSubCollectionViews(_ collectionViews: [UICollectionView]){
        subCollectionViews = collectionViews

        subCollectionViews.forEach { collectionView in
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
}



// MARK: - DataSource
extension PagingCollectionView: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self {
            return subCollectionViews.count
        } else {
            return pagingDataSource?.pagingCollectionView(collectionView, numberOfItemsInSection: section) ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: pagingCollecitionViewCellIdenifire, for: indexPath)
            let subCollectionView = subCollectionViews[indexPath.row]
            subCollectionView.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height)
            cell.addSubview(subCollectionView)
            
            return cell
            
        }else{
            return pagingDataSource?.pagingCollectionView(collectionView, cellForItemAt: indexPath) ?? UICollectionViewCell()
        }
    }
}



// MARK: - Delegate
extension PagingCollectionView: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView != self {
            pagingDelegate?.pagingCollectionView(collectionView, didSelectItemAt: indexPath)
        }
    }
}



// MARK: - FlowLayout
extension PagingCollectionView: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self {
            return CGSize(width: frame.width, height: frame.height)
            
        }else{
            return pagingDelegateFlowLayout?.pagingCollectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath) ?? CGSize(width: 100, height: 100)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self{
            return 0
        }else{
            return pagingDelegateFlowLayout?.pagingCollectionView(collectionView, layout: collectionViewLayout, minimumLineSpacingForSectionAt: section) ?? 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self{
            return 0
        }else{
            return  pagingDelegateFlowLayout?.pagingCollectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: section) ?? 5
        }
    }
}



// MARK: - Scroll Delegate
extension PagingCollectionView: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == 0 {
            // Sub Collection Views is scrolling Verticaly
            scrollDelegate?.pagingCollectionViewsDidScrollSubCollectionView(scrollView)
        }
        
        if scrollView.contentOffset.x != 0 {
            // Paging Collection View is scrolling Horizontaly
            scrollWithSegmentDelegate?.pagingCollectionViewDidScroll(for: scrollView.contentOffset.x)
        }
        
        if scrollView.contentOffset.y == 0 {
            // Prevent selectedIndex form reset to zero
            let selectedIndex = scrollView.contentOffset.x / frame.width
            let roundSelectedIndex = round(selectedIndex)
            
            scrollDelegate?.pagingCollectionViewDidSelectSubCollectionView(at: Int(roundSelectedIndex))
        }
    }
}



// MARK: - Segment Control Delegate
extension PagingCollectionView: CustomSegmentControlDelegate{
    func didIndexChange(at index: Int) {
        // button did pressed on CustomSegmentControl
        scrollRectToVisible(CGRect(x: frame.width * CGFloat(index), y: frame.origin.y, width: frame.width, height: frame.height), animated: true)
    }
}
