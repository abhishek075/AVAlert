//
//  AVAlert.swift
//  Kiddy
//
//  Created by Admin on 06/06/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

@objc open class AVAlert: NSObject {
    
    static let shared = AVAlert()
    
    class var instance : AVAlert {
        struct Static {
            static let inst : AVAlert = AVAlert ()
        }
        return Static.inst
    }
    
    fileprivate func baseController() -> UIViewController? {
        let keyWindow = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first
        var presentedVC = keyWindow?.rootViewController
        while let pVC = presentedVC?.presentedViewController
        {
            presentedVC = pVC
        }

        if presentedVC == nil {
            print(" Error: You don't have any views set. You may be calling in viewdidload. Try viewdidappear.")
        }
        return presentedVC
    }
    
        //==========================================================================================================
        // MARK: - Class Functions
        //==========================================================================================================
        
        @discardableResult
        open class func alert(_ title: String) -> UIAlertController {
            return alert(title, message: "")
        }
        
        @discardableResult
        open class func alert(_ title: String, message: String) -> UIAlertController {
            return alert(title, message: message, acceptMessage: "OK", acceptBlock: {
                // Do nothing
            })
        }

        @discardableResult
        open class func alert(_ title: String, message: String, acceptMessage: String, acceptBlock: @escaping () -> ()) -> UIAlertController {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            let acceptButton = UIAlertAction(title: acceptMessage, style: .default, handler: { (action: UIAlertAction) in
                acceptBlock()
            })
            alert.addAction(acceptButton)

            instance.baseController()?.present(alert, animated: true, completion: nil)
            return alert
        }

        @discardableResult
        open class func alert(_ title: String, message: String, buttons:[String], tapBlock:((UIAlertAction,Int) -> Void)?) -> UIAlertController{
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert, buttons: buttons, tapBlock: tapBlock)
            instance.baseController()?.present(alert, animated: true, completion: nil)
            return alert
        }
        
        @discardableResult
        open class func alert(_ title: String, message: String, buttons:[String], buttonsPreferredStyle:[UIAlertAction.Style], tapBlock:((UIAlertAction,Int) -> Void)?) -> UIAlertController{
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert, buttons: buttons, buttonsPreferredStyle: buttonsPreferredStyle, tapBlock: tapBlock)
            instance.baseController()?.present(alert, animated: true, completion: nil)
            return alert
        }
        
        @discardableResult
        open class func alert(_ title: String, message: String, actions: [UIAlertAction]) -> UIAlertController {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            for action in actions {
                alert.addAction(action)
            }
            instance.baseController()?.present(alert, animated: true, completion: nil)
            return alert
        }

        @discardableResult
        open class func actionSheet(_ title: String, message: String, sourceView: UIView, actions: [UIAlertAction]) -> UIAlertController {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.actionSheet)
            for action in actions {
                alert.addAction(action)
            }
            alert.popoverPresentationController?.sourceView = sourceView
            alert.popoverPresentationController?.sourceRect = sourceView.bounds
            instance.baseController()?.present(alert, animated: true, completion: nil)
            return alert
        }

        @discardableResult
        open class func actionSheet(_ title: String, message: String, sourceView: UIView, buttons:[String], tapBlock:((UIAlertAction,Int) -> Void)?) -> UIAlertController{
            let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet, buttons: buttons, tapBlock: tapBlock)
            alert.popoverPresentationController?.sourceView = sourceView
            alert.popoverPresentationController?.sourceRect = sourceView.bounds
            instance.baseController()?.present(alert, animated: true, completion: nil)
            return alert
        }

    }

    private extension UIAlertController {
        convenience init(title: String?, message: String?, preferredStyle: UIAlertController.Style, buttons:[String], tapBlock:((UIAlertAction,Int) -> Void)?) {
            self.init(title: title, message: message, preferredStyle:preferredStyle)
            var buttonIndex = 0
            for buttonTitle in buttons {
                let action = UIAlertAction(title: buttonTitle, preferredStyle: .default, buttonIndex: buttonIndex, tapBlock: tapBlock)
                buttonIndex += 1
                self.addAction(action)
            }
        }
        
        convenience init(title: String?, message: String?, preferredStyle: UIAlertController.Style, buttons:[String], buttonsPreferredStyle:[UIAlertAction.Style], tapBlock:((UIAlertAction,Int) -> Void)?) {
            self.init(title: title, message: message, preferredStyle:preferredStyle)
            var buttonIndex = 0
            for buttonTitle in buttons {
                let action = UIAlertAction(title: buttonTitle, preferredStyle: buttonsPreferredStyle[buttonIndex], buttonIndex: buttonIndex, tapBlock: tapBlock)
                buttonIndex += 1
                self.addAction(action)
            }
        }
    }

    private extension UIAlertAction {
        convenience init(title: String?, preferredStyle: UIAlertAction.Style = .default, buttonIndex:Int, tapBlock:((UIAlertAction,Int) -> Void)?) {
            self.init(title: title, style: preferredStyle) {
                (action:UIAlertAction) in
                if let block = tapBlock {
                    block(action,buttonIndex)
                }
            }
        }
    }
