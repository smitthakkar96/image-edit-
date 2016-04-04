//
//  ViewController.swift
//  Task
//
//  Created by smit thakkar on 04/04/16.
//  Copyright © 2016 smit thakkar. All rights reserved.
//

import UIKit
import imglyKit

class ViewController: UIViewController,UIGestureRecognizerDelegate {
    lazy var imageView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer(target: self, action: Selector("handle:"))
        panGesture.delegate = self
        let pinch = UIPinchGestureRecognizer(target: self, action: Selector("scaleImage:"))
        pinch.delegate = self
        view.addGestureRecognizer(pinch)
        view.addGestureRecognizer(panGesture)
        self.view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setNeedsUpdateConstraints()
        imageView.contentMode = .ScaleAspectFit
        let navigationBar = UINavigationBar(frame: CGRectMake(0, 0, self.view.frame.size.width, 44)) // Offset by 20 pixels vertically to take the status bar into account
        
        navigationBar.backgroundColor = UIColor.redColor()
        let navigationItem = UINavigationItem()
        let leftButton =  UIBarButtonItem(title: "Save", style:   UIBarButtonItemStyle.Plain, target: self, action: Selector("btn_clicked:"))
        navigationItem.rightBarButtonItem = leftButton
        navigationBar.items = [navigationItem]
        self.view.addSubview(navigationBar)
    }
    func btn_clicked(sender:AnyObject)
    {
       let img = self.view.pb_takeSnapshot()
        UIImageWriteToSavedPhotosAlbum(img, self, nil, nil)
    }
    lazy var lastLocation=CGPoint(x: 0,y: 0)
    override func viewDidAppear(animated: Bool) {
        let taylor = UIImage(named: "taylor")
        let filter = IMGLYInstanceFactory.effectFilterWithType(.Steel)
        let filteredImage = IMGLYPhotoProcessor.processWithUIImage(taylor!, filters: [filter])
        let editorViewController = IMGLYMainEditorViewController()
        editorViewController.highResolutionImage = taylor
        editorViewController.initialFilterType = .None
        editorViewController.initialFilterIntensity = 0.5
//        editorViewController.completionBlock = editorCompletionBlock
//        uncomment below line to open image edit view controller
//        self.presentViewController(editorViewController, animated: true, completion: nil)
        imageView.image = filteredImage
        lastLocation = self.view.center
    }
    func scaleImage(sender: UIPinchGestureRecognizer) {
        self.view.transform = CGAffineTransformScale(self.view.transform, sender.scale, sender.scale)
        sender.scale = 1
    }
    
    func handle(recognizer:UIPanGestureRecognizer)
    {
        
        let translation  = recognizer.translationInView(self.view)
        print(translation)
        imageView.center = CGPointMake(lastLocation.x + translation.x, lastLocation.y + translation.y)
    }

    func editorCompletionBlock(result: IMGLYEditorResult, image: UIImage?) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func updateViewConstraints() {
        NSLayoutConstraint(item: imageView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0.5).active = true
        NSLayoutConstraint(item: imageView, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1.0, constant: 0).active = true
        NSLayoutConstraint(item: imageView, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 0).active=true
        NSLayoutConstraint(item: imageView, attribute: .Height, relatedBy: .LessThanOrEqual, toItem: view, attribute: .Height, multiplier: 1.0, constant: 0.5).active = true
        NSLayoutConstraint(item: imageView, attribute: .Width, relatedBy: .LessThanOrEqual, toItem: view, attribute: .Width, multiplier: 1.0, constant: 0.5).active = true
        super.updateViewConstraints()
    }

}
extension UIView {
    
    func pb_takeSnapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.mainScreen().scale)
        
        drawViewHierarchyInRect(self.bounds, afterScreenUpdates: true)
        
        // old style: layer.renderInContext(UIGraphicsGetCurrentContext())
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

