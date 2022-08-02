//
//  Extension.swift
//  Demo App MVC
//
//  Created by Hassan Rafique on 7/31/22.
//

import UIKit
import Foundation

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}

extension UIView {
    func addTopViewLayer() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: self.bounds.maxX, y: self.bounds.minY))
        path.addLine(to: CGPoint(x: self.bounds.minX, y: self.bounds.maxY))
        path.addLine(to: CGPoint(x: self.bounds.minX, y: self.bounds.minY))
        path.addLine(to: CGPoint(x: self.bounds.maxX, y: self.bounds.minY))
        
        path.move(to: CGPoint(x: self.bounds.maxX, y: self.bounds.minY))
        path.addQuadCurve(to: CGPoint(x: self.bounds.minX, y: self.bounds.maxY), controlPoint: CGPoint(x: self.bounds.midX + self.bounds.midX/2, y: self.bounds.maxY * 1.1))
        
        
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        self.layer.mask = shape
    }
    
    func addBottomRightViewLayer() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: self.bounds.maxX, y: self.bounds.minY))
        path.addLine(to: CGPoint(x: self.bounds.minX, y: self.bounds.maxY))
        path.addLine(to: CGPoint(x: self.bounds.maxX, y: self.bounds.maxY))
        path.addLine(to: CGPoint(x: self.bounds.maxX, y: self.bounds.minY))
        
        path.move(to: CGPoint(x: self.bounds.maxX, y: self.bounds.minY))
        path.addQuadCurve(to: CGPoint(x: self.bounds.minX, y: self.bounds.maxY), controlPoint: CGPoint(x: self.bounds.midX - self.bounds.midX/2, y: self.bounds.minY))
        
        
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        self.layer.mask = shape
    }
    
    func addBottomLeftViewLayer() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: self.bounds.minX, y: self.bounds.minY))
        path.addLine(to: CGPoint(x: self.bounds.maxX, y: self.bounds.maxY))
        path.addLine(to: CGPoint(x: self.bounds.minX, y: self.bounds.maxY))
        path.addLine(to: CGPoint(x: self.bounds.minX, y: self.bounds.minY))
        
        path.move(to: CGPoint(x: self.bounds.minX, y: self.bounds.minY))
        path.addQuadCurve(to: CGPoint(x: self.bounds.maxX, y: self.bounds.maxY), controlPoint: CGPoint(x: self.bounds.midX + self.bounds.midX/2, y: self.bounds.minY))
        
        
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        self.layer.mask = shape
    }
}

extension UIViewController {
    func showAlertPopup(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = self.view.bounds
        }
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIColor {
    class func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        //        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
