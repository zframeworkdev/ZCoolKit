//
//  UIAlertViewController+Ext.swift
//  ForceUpdateApp
//
//  Created by Zaldy on 28/09/2018.
//  Copyright © 2018 Zaldy. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

extension UIAlertAction {
    private struct AssociatedKeys {
        static var tag = "tag"
    }
    //this lets us check to see if the item is supposed to be displayed or not
    var tag : Int {
        get {
            guard let number = objc_getAssociatedObject(self, &AssociatedKeys.tag) as? NSNumber else {
                return 0
            }
            return number.intValue
        }
        
        set(value) {
            objc_setAssociatedObject(self,&AssociatedKeys.tag, NSNumber(value: value),objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension String {
    func sizeForWidth(width: CGFloat, font: UIFont) -> CGSize {
        let attr = [NSAttributedString.Key.font: font]
        let height = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options:.usesLineFragmentOrigin, attributes: attr, context: nil).height
        return CGSize(width: width, height: ceil(height))
    }
}

extension UIAlertController {
    @discardableResult class func showAlert(buttonTitles:[String]?, title: String?, message: String?, cancel:String?, handler: ((_ actionIndex: Int)->Void)?) -> UIAlertController? {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        var index = 0
        buttonTitles?.forEach({ bTitle in
            let alertAction = UIAlertAction(title: bTitle, style: .default, handler: {(alert: UIAlertAction!) in
                
                DispatchQueue.main.async {
                    handler?(alert.tag)
                }
            })
            alertAction.tag = index
            alert.addAction(alertAction)
            index = index + 1
        })
        
        // Cancel
        if let cancelTitle = cancel {
            let defaultAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: {(alert: UIAlertAction!) in
                handler?(-1)
            })
            alert.addAction(defaultAction)
        }
        
        let topViewController = UIApplication.topViewController()
        topViewController?.present(alert, animated: true, completion: nil)
        //target?.present(alert, animated: true, completion: nil)
        return alert
    }
    
    class func showAlertWithTextView(title: String, text: String, buttonTitles:[String]?,
                                     handler: ((_ actionIndex: Int)->Void)?) {
        
        //let text = "After 06/30/2017, the <insert app name> on this device will no longer be supported, but you can still access this app on the web at www.google.com"
        let titleLabelRect = CGRect(x: 15, y: 20, width: 240, height: 50)
        let titleLabel = UILabel(frame: titleLabelRect)
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.backgroundColor = UIColor.green
        titleLabel.text = title
        titleLabel.numberOfLines = 0
        titleLabel.sizeToFit()
        //titleLabel.frame.size.width = 240
        
        // each line is 30 pixels height
        let rect = CGRect(x: 15, y: titleLabel.frame.maxY, width: 240, height: 1)
        let textView = UITextView(frame: rect)
        
        textView.font = UIFont.systemFont(ofSize: 13.0)
        textView.textColor = UIColor.black
        textView.backgroundColor = UIColor.clear
        textView.textAlignment = .center
        //textView.layer.borderColor = UIColor.green.cgColor
        //textView.layer.borderWidth = 1.0
        textView.text = text
        textView.isSelectable = true
        textView.dataDetectorTypes = .link
        textView.isEditable = false
        textView.sizeToFit()
        textView.frame.size.width = 240
        
        //textView.frame.size.height = 30
        //let numLines = textView.contentSize.height / (textView.font?.lineHeight)!
        //let numberOfNextLineCharacters = Int(ceilf(Float(numLines / 2.0)))
        
        /*
         IMPORTANT!
         @ If the message text content is huge where it could exceed the screen size,
         be sure to make the textview scrollable and adjust its height
         */
        let window = UIApplication.shared.delegate?.window as? UIWindow
        let usedHeight = titleLabel.frame.height + 40.0 // 40 is the buttons height below
        let allowedHeight = ((window?.frame.size.height)! - usedHeight) - 20.0 // 20.0 == padding
        var textViewTextContentHeight = textView.text.sizeForWidth(width:textView.contentSize.width, font: textView.font!).height
        if (textView.frame.size.height > allowedHeight) {
            textView.frame.size.height = allowedHeight
            textViewTextContentHeight = allowedHeight
            textView.isScrollEnabled = true
        }
        
        let lines = Int(textViewTextContentHeight / (textView.font?.lineHeight)!)
        var lineCharacters = ""
        for _ in 0...(lines - 1) {
            lineCharacters.append("\n")
        }
        
        print("Number of lines: \(lines)")
        //print("Number of Rows: \(rows)")
        //print("Number of lines: \(numLines)")
        let alert = UIAlertController.showAlert(buttonTitles: buttonTitles, title: title, message: "\(lineCharacters)", cancel: nil, handler: handler)
        alert?.view.addSubview(textView)
    }
}
