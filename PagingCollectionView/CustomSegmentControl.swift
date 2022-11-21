//
//  CustomSegmentControl.swift
//  PagingCollectionView
//
//  Created by Khater on 11/21/22.
//

import UIKit

// MARK: - Protocol
protocol CustomSegmentControlDelegate: NSObject{
    func didIndexChange(at index: Int)
}

// MARK: - Class
@IBDesignable class CustomSegmentControl: UIView{
    
    // MARK: Properties
    public weak var delegate: CustomSegmentControlDelegate?
    
    private var buttonsStackView: UIStackView?
    private var lineView: UIView?
    private var selectedButtonLineView: UIView?
    
    private var buttons: [UIButton] = []
    
    // MARK: - IBInspectable's
    @IBInspectable var textColor: UIColor = .blue{
        didSet{
            for button in buttons {
                button.tintColor = textColor
            }
        }
    }
    
    @IBInspectable var lineColor: UIColor = .black {
        didSet{
            selectedButtonLineView?.backgroundColor = lineColor
        }
    }
    
    @IBInspectable var commaSeparatedButtonTitles: String = ""{
        didSet{
            buttons.removeAll()
            
            let buttonTitles = commaSeparatedButtonTitles.components(separatedBy: ",")
            
            for buttonTitle in buttonTitles {
                let button = UIButton(type: .system)
                button.setTitle(buttonTitle, for: .normal)
                button.titleLabel?.font = UIFont(name: "Inter-Regular", size: 17)
                button.titleLabel?.numberOfLines = 0
                button.addTarget(self, action: #selector(selectButton(_:)), for: .touchUpInside)
                
                buttons.append(button)
            }
            
            updateView()
        }
    }
    
    
    // MARK: - Update UI
    private func updateView(){
        removeAll()
        setupUI()
        addToSubview()
        setupConstraints()
    }
    
    private func removeAll(){
        subviews.forEach { view in
            view.removeFromSuperview()
        }
        buttonsStackView = nil
        lineView = nil
        selectedButtonLineView = nil
    }
    
    private func setupUI(){
        setupButtonsStackView()
        setupSelectedButtonLineView()
        setupLineView()
    }
    
    private func addToSubview(){
        addSubview(buttonsStackView!)
        lineView?.addSubview(selectedButtonLineView!)
        addSubview(lineView!)
    }
    
    private func setupConstraints(){
        addConstraintToButtonsStackView()
        addConstraintToLineView()
        addConstraintToSelectedButtonLineView()
    }
    
    // MARK: - Setup UI
    private func setupButtonsStackView(){
        buttonsStackView = UIStackView(arrangedSubviews: buttons)
        buttonsStackView?.axis = .horizontal
        buttonsStackView?.alignment = .fill
        buttonsStackView?.distribution = .fillEqually
    }
    
    private func setupLineView(){
        lineView = UIView()
        lineView?.backgroundColor = .lightGray
    }
    
    private func setupSelectedButtonLineView(){
        selectedButtonLineView = UIView()
        selectedButtonLineView?.backgroundColor = .black
    }
    
    // MARK: - Constraint's
    private func addConstraintToButtonsStackView(){
        buttonsStackView?.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView?.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        buttonsStackView?.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        buttonsStackView?.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    private func addConstraintToLineView(){
        lineView?.translatesAutoresizingMaskIntoConstraints = false
        lineView?.heightAnchor.constraint(equalToConstant: 2).isActive = true
        lineView?.topAnchor.constraint(equalTo: buttonsStackView!.bottomAnchor).isActive = true
        lineView?.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        lineView?.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        lineView?.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    private func addConstraintToSelectedButtonLineView(){
        selectedButtonLineView?.translatesAutoresizingMaskIntoConstraints = false
        selectedButtonLineView?.heightAnchor.constraint(equalToConstant: 2).isActive = true
        selectedButtonLineView?.widthAnchor.constraint(equalToConstant: (frame.width / CGFloat(buttons.count))).isActive = true
        selectedButtonLineView?.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        selectedButtonLineView?.topAnchor.constraint(equalTo: buttonsStackView!.bottomAnchor).isActive = true
        selectedButtonLineView?.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    
    // MARK: - Button Action
    @objc private func selectButton(_ button: UIButton){
        let selectedButtonIndex = buttons.firstIndex(of: button)!
        
        if delegate != nil {
            // The delegate will change the selectedButtonLineView position
            delegate!.didIndexChange(at: selectedButtonIndex)
            
        } else {
            guard selectedButtonLineView?.transform.tx != button.frame.origin.x else { return }
            
            UIView.animate(withDuration: 0.3) {
                self.selectedButtonLineView?.transform.tx = button.frame.origin.x
            }
        }
    }
}


extension CustomSegmentControl: PagingCollectionViewLinkedWithSegmentControlDelegate {
    func pagingCollectionViewDidScroll(for x: CGFloat) {
        let index = Int(round(x / frame.width))
        var buttonPositionX: CGFloat = 0
        if index < buttons.count{
            buttonPositionX = buttons[index].frame.origin.x
        }
        
        let positionX = (x / CGFloat(buttons.count))
        
        if index == (buttons.count - 1) {
            if positionX < buttonPositionX {
                selectedButtonLineView?.transform.tx = positionX
            }
        }else{
            selectedButtonLineView?.transform.tx = positionX
        }
    }
}
