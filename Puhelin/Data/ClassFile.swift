//
//  ClassFile.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/03/11.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import Foundation
import UIKit


class LeftFixedImageButton: UIButton {
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let rect = super.titleRect(forContentRect: contentRect)
        if let imgView = self.imageView {
            return CGRect(x: rect.minX - imgView.image!.size.width / 2, y: rect.minY, width: rect.width, height: rect.height)
        }
        return rect
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let rect = super.imageRect(forContentRect: contentRect)
        return CGRect(x: 20.0, y: rect.minY, width: rect.width, height: rect.height)
    }
    
}

extension UIButton {
    // ボタンのアイコンをLeading(右側)に表示する
    func iconToRight() {
        if #available(iOS 11.0, *) {
            // leadingはiOS 11以降のため
            contentHorizontalAlignment = .leading
        } else {
            contentHorizontalAlignment = .right
        }
        semanticContentAttribute =
            UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft
            ? .forceLeftToRight : .forceRightToLeft
    }
}

extension Array where Element: Equatable {
    mutating func remove(value: Element) {
        if let i = self.firstIndex(of: value) {
            self.remove(at: i)
        }
    }
}

//UIimageの角丸
extension UIImage {
    
    func imageWithCornerRadius(cornerRadius: CGFloat) -> UIImage{
        
        var imageBounds: CGRect
        let scaleForDisplay = UIScreen.main.scale     //1ポイント当たり何ピクセルか
        let cornerRadius = cornerRadius * scaleForDisplay     //ポイントからピクセルへの変換
        imageBounds = CGRect(x: 0, y: 0, width: self.size.height, height: self.size.height)
 
        //角丸のマスクを作成する
        let path = UIBezierPath.init(roundedRect: imageBounds, cornerRadius: cornerRadius)
        UIGraphicsBeginImageContextWithOptions(path.bounds.size, false, 0.0)
        let fillColor = UIColor.blue
        fillColor.setFill()
        path.fill()
        let maskImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //元イメージにマスクをかける
        UIGraphicsBeginImageContextWithOptions(path.bounds.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        context!.clip(to: imageBounds, mask: (maskImage?.cgImage)!)
        self.draw(at: .zero)
        
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resultImage!
        
    }
    
}
//
//行数を取得する
//
extension UITextView {
    var numberOfLines: Int {
        // prepare
        var computingLineIndex = 0
        var computingGlyphIndex = 0
        // compute
        while computingGlyphIndex < layoutManager.numberOfGlyphs {
            var lineRange = NSRange()
            layoutManager.lineFragmentRect(forGlyphAt: computingGlyphIndex, effectiveRange: &lineRange)
            computingGlyphIndex = NSMaxRange(lineRange)
            computingLineIndex += 1
        }
        // return
        if textContainer.maximumNumberOfLines > 0 {
            return min(textContainer.maximumNumberOfLines, computingLineIndex)
        } else {
            return computingLineIndex
        }
    }
}

//
//指定した箇所に枠線をつける
//
enum BorderPosition {
    case top
    case left
    case right
    case bottom
}

extension UIView {
    /// 特定の場所にborderをつける
    ///
    /// - Parameters:
    ///   - width: 線の幅
    ///   - color: 線の色
    ///   - position: 上下左右どこにborderをつけるか
    func addBorder(width: CGFloat, color: UIColor, position: BorderPosition) {

        let border = CALayer()

        switch position {
        case .top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: width)
            border.backgroundColor = color.cgColor
            self.layer.addSublayer(border)
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.height)
            border.backgroundColor = color.cgColor
            self.layer.addSublayer(border)
        case .right:
            border.frame = CGRect(x: self.frame.width - width, y: 0, width: width, height: self.frame.height)
            border.backgroundColor = color.cgColor
            self.layer.addSublayer(border)
        case .bottom:
            border.frame = CGRect(x: 0, y: self.frame.height - width, width: self.frame.width, height: width)
            border.backgroundColor = color.cgColor
            self.layer.addSublayer(border)
        }
    }
}


//nortificationCenter用
extension Notification.Name {
    static let NewMessage = Notification.Name("NewMessage")
}
