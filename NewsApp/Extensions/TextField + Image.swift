//
//  TextField + Image.swift
//  NewsApp
//
//  Created by Hakan Or on 21.07.2022.
//

import Foundation
import UIKit

extension UITextField {
    func leftImage(_ image: UIImage?, imageWidth: CGFloat, padding: CGFloat) {
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: padding, y: 0, width: imageWidth, height: frame.height)
        imageView.contentMode = .center
        imageView.tintColor = .black
        imageView.alpha = 0.5
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: imageWidth + 2 * padding, height: frame.height))
        containerView.addSubview(imageView)
        leftView = containerView
        leftViewMode = .always
    }
    
    func rightImage(_ image: UIImage?, imageWidth: CGFloat, padding: CGFloat) {
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: padding, y: 0, width: imageWidth, height: frame.height)
        imageView.contentMode = .center
        imageView.tintColor = .black
        imageView.alpha = 0.5
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: imageWidth + 2 * padding, height: frame.height))
        containerView.addSubview(imageView)
        rightView = containerView
        rightViewMode = .always
    }
    
    func rightButton(_ image: UIImage?, imageWidth: CGFloat, padding: CGFloat) {
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: padding, y: 0, width: imageWidth, height: frame.height)
        imageView.contentMode = .center
        imageView.tintColor = .black
        imageView.alpha = 0.5
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: imageWidth + 2 * padding, height: frame.height))
        containerView.addSubview(imageView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(didTouchClearAllButton(sender:)))
        containerView.addGestureRecognizer(tapGesture)
        
        rightView = containerView
        rightViewMode = .always
        
    }
    @objc func didTouchClearAllButton(sender: UIButton) {
        text = ""
    }
}
