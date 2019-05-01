//
//  FleetRoot.swift
//  FleetIOSPod
//
//  Created by Steve Sheets on 4/15/19.
//

import UIKit

// MARK: Global Variables

public var g_fleet_root_view_controller: FleetRootViewController?

// MARK: Class

/// Root View Controller class for Fleet
public class FleetRootViewController: FleetViewController {
    
    // MARK: IBOutlets Properties
    
    /// Optional View to emulate launch screen
    @IBOutlet public weak var launchScreenView: UIView?
    
    // MARK: Inspectable Properties
    
    /// First Storyboard ID (required)
    @IBInspectable public var firstDisplay: String = ""
    
    // MARK: Properties
    
    /// Name of main storyboard
    var mainStoryboad = "Main"
    
    /// Animation to use to hide Launch View
    var launchAnimStyle = UIView.animStyle.fade
    
    // MARK: Private Properties
    
    /// Main Container View
    private var container: FleetContainerView?
    
    /// Height of keyboard box
    private var keyboardHeight = CGFloat(0.0)
    
    /// Bottom Constraint of container
    private var bottomContraint: NSLayoutConstraint? = nil
    
    // MARK: Class Methods
    
    /// Returns width of screen
    ///
    /// - Returns: CGFloat containing width.
    public class func RootWidth() -> CGFloat {
        return g_fleet_root_view_controller?.view.bounds.width ?? 0.0
    }
    
    /// Returns height of screen
    ///
    /// - Returns: CGFloat containing height.
    public class func RootHeight() -> CGFloat {
        return g_fleet_root_view_controller?.view.bounds.height ?? 0.0
    }
    
    // MARK: Lifecycle Methods
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        g_fleet_root_view_controller = self
        
        container = FleetContainerView()
        if let container = container {
            container.backgroundColor = .clear
            container.isOpaque = false
            container.frame = self.view.bounds
            container.parentController = self
            view.addSubview(container)

            bottomContraint = container.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
                
            if let bottomContraint = bottomContraint {
                NSLayoutConstraint.useAndActivateConstraints(constraints:[
                    container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
                    container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
                    container.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
                    bottomContraint
                    ])
            }
        }
        
        
        let center = NotificationCenter.default
        let mainQueue = OperationQueue.main
        center.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: mainQueue, using:  {note in
            self.keyboardShowing(note: note)
        })
        center.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: mainQueue, using:  {note in
            self.keyboardHiding(note: note)
        })
        
        g_fleet_app_delegate?.appBegin()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        hideLaunch()
    }
    
    // MARK: Public Methods
    
    /// Hide Launch view (if not nil), then call show First view controller
    public func hideLaunch() {
        if let launchScreenView = launchScreenView {
            launchScreenView.animFadeOut(withCompletion: { self.showFirstViewController() } )
        }
        else {
            showFirstViewController()
        }
    }
    
    /// Display first launch view controller
    public func showFirstViewController() {
        if self.firstDisplay.count>0 {
            if let container = container {
                let story = UIStoryboard(name: mainStoryboad, bundle: nil)
                let vc = story.instantiateViewController(withIdentifier: self.firstDisplay)
                
                container.fill(controller: vc, removeAnim:launchAnimStyle)
            }
        }
    }
    
    /// Push named view controller onto stack on root
    ///
    /// - Parameter name: String with storyboard id
    /// - Returns: Returns View Controller created and pushed
    @discardableResult
    public func push(name: String, fillBlock: FleetContainerView.ContainerFillClosure? = nil) -> UIViewController? {
        if let container = container {
            return container.push(name: name, fillBlock: fillBlock)
        }
        
        return nil
    }
    
    /// Push view controller onto stack of root
    ///
    /// - Parameter controller: View Controller to push
    public func push(controller: UIViewController, fillBlock: FleetContainerView.ContainerFillClosure? = nil) {
        if let container = container {
            container.push(controller: controller, fillBlock: fillBlock)
        }
    }
    
    /// Pop root container
    public func pop() {
        if let container = container {
            UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
            container.pop()
        }
    }
    
    // MARK: Private Mrethods
    
    private func viewAnimationOptionForCurve(curve: UIView.AnimationCurve) -> UIView.AnimationOptions {
        switch (curve) {
        case .easeInOut:
            return UIView.AnimationOptions.curveEaseInOut
        case .easeIn:
            return UIView.AnimationOptions.curveEaseIn
        case .easeOut:
            return UIView.AnimationOptions.curveEaseOut
        case .linear:
            return UIView.AnimationOptions.curveLinear
        default:
            return UIView.AnimationOptions.curveLinear
        }
    }
    
    /// Handle Keyboard Height
    private func keyboard(newHeight: CGFloat, note: Notification) {
        var duration = TimeInterval(0.5)
        var curve = UIView.AnimationOptions.curveLinear
        if let info = note.userInfo as NSDictionary? {
            if let durationNumber = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber {
                duration = durationNumber.doubleValue
            }
            if let curveNumber = info[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber {
                curve = UIView.AnimationOptions(rawValue: UInt(curveNumber.intValue))
            }
        }
        
        if newHeight != keyboardHeight {
            if let bottomContraint = bottomContraint {
                UIView.animate(withDuration: duration,
                               delay: TimeInterval(0.0),
                               options: [curve],
                               animations: {
                                self.view.setNeedsLayout()
                                bottomContraint.constant = -newHeight
                                self.view.layoutIfNeeded()
                },
                               completion: nil)
            }
            keyboardHeight = newHeight
        }
        
    }
    
    /// Handle the Keyboard showing
    private func keyboardShowing(note: Notification) {
        var h = CGFloat.zero
        if let info = note.userInfo as NSDictionary? {
            if let value = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let box = value.cgRectValue;
                h = box.size.height
            }
        }
        keyboard(newHeight: h, note: note)
    }
    
    /// Handle the keyboard hiding
    private func keyboardHiding(note: Notification) {
        keyboard(newHeight: CGFloat.zero, note: note)
    }
}
