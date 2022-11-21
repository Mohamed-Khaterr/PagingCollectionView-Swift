//
//  SecondViewController.swift
//  PagingCollectionView
//
//  Created by Khater on 11/21/22.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var customSegmentControl: CustomSegmentControl!
    @IBOutlet weak var pagingCollectionView: PagingCollectionView!
        
    private var firstCollectionView: UICollectionView?
    private var secondCollectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        secondCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        firstCollectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        secondCollectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        pagingCollectionView.pagingDelegate = self
        pagingCollectionView.pagingDataSource = self
        pagingCollectionView.addSubCollectionViews([firstCollectionView!, secondCollectionView!])
        pagingCollectionView.segmentControl = customSegmentControl
        pagingCollectionView.scrollDelegate = self
    }
    
    deinit{
        print("SecondViewController deinit")
    }
}

// MARK: - PagingCollectionView DataSource
extension SecondViewController: PagingCollectionViewDataSource{
    func pagingCollectionView(_ subCollectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if subCollectionView == firstCollectionView{
            return 10
        } else if subCollectionView == secondCollectionView {
            return 100
        }
        fatalError()
    }

    func pagingCollectionView(_ subCollectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = subCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)

        if subCollectionView == firstCollectionView{
            cell.backgroundColor = .cyan
        }else {
            cell.backgroundColor = .yellow
        }
        
        return cell
    }
}


// MARK: - PagingCollectionView Delegat
extension SecondViewController: PagingCollectionViewDelegate {
    func pagingCollectionView(_ subCollectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if subCollectionView == firstCollectionView {
            print("First Collection View Cell Pressed")
        } else if subCollectionView == secondCollectionView {
            print("Second Collection View Cell Pressed")
        }
    }
}


extension SecondViewController: PagingCollectionViewScrollDelegate{
    func pagingCollectionViewDidSelectSubCollectionView(at index: Int) {
        print("Selected Collection View:", index)
    }
}
