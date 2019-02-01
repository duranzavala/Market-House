//
//  SegmentedControl.swift
//  Rent House
//
//  Created by Arnulfo on 1/17/19.
//  Copyright © 2019 Arnulfo. All rights reserved.
//
import UIKit

class SegmentedControl: UIControl {
    
    var buttons = [UIButton]()
    var selector: UIView!
    var selectedSegmentIndex = 0
    
    @IBInspectable
    var borderWidth: CGFloat = 0{
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var borderColor: UIColor = UIColor.clear{
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable
    var commaSeparatedButtonTitles: String = ""{
        didSet{
            updateView()
        }
    }
    
    @IBInspectable
    var textColor: UIColor = .lightGray{
        didSet{
            updateView()
        }
    }
    
    @IBInspectable
    var selectorColor: UIColor = .darkGray{
        didSet{
            updateView()
        }
    }
    
    @IBInspectable
    var selectorTextColor: UIColor = .white{
        didSet{
            updateView()
        }
    }
    
    func updateView(){
        buttons.removeAll()
        subviews.forEach { $0.removeFromSuperview() }
        
        let buttonTitles = commaSeparatedButtonTitles.components(separatedBy: ",")
        
        for buttonTitle in buttonTitles{
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.setTitleColor(textColor, for: .normal)
            button.titleLabel!.font = UIFont(name: "Arial", size: 16)
            button.contentVerticalAlignment = .top
            button.addTarget(self, action: #selector(buttonTapped(button: )), for: .touchUpInside)
            buttons.append(button)
        }
        
        buttons[0].setTitleColor(selectorTextColor, for: .normal)
        
        let selectorWidth = frame.width / CGFloat(buttonTitles.count)
        selector = UIView(frame: CGRect(x: 0, y: 0, width: selectorWidth, height: frame.height))
        selector.layer.cornerRadius = frame.height/2
        selector.backgroundColor = selectorColor
        addSubview(selector)
        
        let sv = UIStackView(arrangedSubviews: buttons)
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .fillEqually
        addSubview(sv)
        
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.topAnchor.constraint(equalTo: self.topAnchor)
        sv.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        sv.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        sv.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = frame.height/2
        updateView()
    }
    
    @objc func buttonTapped(button: UIButton){
        for (buttonIndex, btn) in buttons.enumerated(){
            btn.setTitleColor(textColor, for: .normal)
            
            if btn == button{
                selectedSegmentIndex = buttonIndex
                let selectorStartPosition = frame.width/CGFloat(buttons.count) * CGFloat(buttonIndex)
                UIView.animate(withDuration: 0.1, animations: {
                    self.selector.frame.origin.x = selectorStartPosition
                    })
                btn.setTitleColor(selectorTextColor, for: .normal)
                btn.contentVerticalAlignment = .top
            }
        }
        sendActions(for: .touchUpInside)
    }
}
