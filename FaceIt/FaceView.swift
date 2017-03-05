    //
    //  FaceView.swift
    //  FaceIt
    //
    //  Created by Saeid.mhd@gmail on 2/26/17.
    //  Copyright © 2017 Saeid mohammadi. All rights reserved.
    //
    
    import UIKit
    @IBDesignable
    class FaceView: UIView {
        
        ///struct CGFloat : The basic type for floating-point scalar values
        ///in Core Graphics and relate frameworks.
        
        @IBInspectable
        var scale : CGFloat = 0.90 {didSet{setNeedsDisplay()}}
        @IBInspectable
        var mouthCurvature: Double = 1.0 {didSet{setNeedsDisplay()}}
        @IBInspectable
        var eyeOpen: Bool = false {didSet{setNeedsDisplay()}}
        @IBInspectable
        var eyeBrowTilt: Double = -0.5 {didSet{setNeedsDisplay()}}// -1 full furrow, 1 fully relaxed
        @IBInspectable
        var color: UIColor = UIColor.blue {didSet{setNeedsDisplay()}}
        @IBInspectable
        var lineWidth : CGFloat = 5.0 {didSet{setNeedsDisplay()}}
        
        /// radius of skull
        private var skullRadius : CGFloat {
            
            ///The bounds rectangle, which describes the view’s location and size in its own coordinate system.
            return min(bounds.size.width, bounds.size.height) / 2 * scale
            
        }
        private var skullCenter : CGPoint{
            
            ///CGPoint : A structure that contains a point in a two-dimensional coordinate system.
            return CGPoint(x: bounds.midX,y: bounds.midY)
            
        }
        
        private struct Ratios{
            
            static let SkullRadiosToEyeOffset: CGFloat = 3
            static let SkullRadiosToEyeRadius: CGFloat = 10
            static let SkullRadiosToMouthWidth: CGFloat = 1
            static let SkullRadiosToMouthHeight: CGFloat = 3
            static let SkullRadiosToMouthOffset: CGFloat = 3
            static let SkullRadiosToBrowOffset: CGFloat = 5
        }
        
        private enum Eye {
            case Left
            case Right
        }
        
        private func pathForCircleCenteredAtPoint(midPoint: CGPoint ,withRadius: CGFloat) -> UIBezierPath {
            
            let path =  UIBezierPath(arcCenter: midPoint,
                                     radius: withRadius,
                                     startAngle: 0.0,
                                     endAngle: CGFloat(2*M_PI) ,
                                     clockwise: false
            )
            
            path.lineWidth = lineWidth
            return path
        }
        
        private func getEyeCenter(eye: Eye) -> CGPoint
        {
            
            let eyeOffset = skullRadius / Ratios.SkullRadiosToEyeOffset
            var eyeCenter = skullCenter
            eyeCenter.y -= eyeOffset
            switch eye {
            case .Left: eyeCenter.x -= eyeOffset
            case .Right: eyeCenter.x += eyeOffset
            }
            return eyeCenter
            
        }
        
        private func pathForEye(eye: Eye) -> UIBezierPath{
            
            let eyeRadius = skullRadius / Ratios.SkullRadiosToEyeRadius
            let eyeCenter = getEyeCenter(eye: eye)
            if eyeOpen{
            return pathForCircleCenteredAtPoint(midPoint: eyeCenter, withRadius: eyeRadius)
            }else{
            
                let path = UIBezierPath()
                path.move(to: CGPoint(x: eyeCenter.x - eyeRadius , y:eyeCenter.y))
                path.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius , y:eyeCenter.y))
                path.lineWidth = lineWidth
                return path
                
            
            }
            
            
        }
        
        private func pathForMouth() -> UIBezierPath
        {
            let mouthWidth = skullRadius / Ratios.SkullRadiosToMouthWidth
            let mouthHeight = skullRadius / Ratios.SkullRadiosToMouthHeight
            let mouthOffset = skullRadius / Ratios.SkullRadiosToMouthOffset
            
            let mouthRect = CGRect(x: skullCenter.x - mouthWidth / 2, y: skullCenter.y + mouthOffset, width: mouthWidth, height: mouthHeight)
            
            let smileOffset = CGFloat(max(-1 , min(mouthCurvature,1))) * mouthRect.height
            let start = CGPoint(x: mouthRect.minX , y: mouthRect.minY)
            let end = CGPoint(x: mouthRect.maxX , y: mouthRect.minY)
            let cp1 =  CGPoint(x: mouthRect.minX + mouthRect.width / 3 , y: mouthRect.minY + smileOffset)
            let cp2 =  CGPoint(x: mouthRect.maxX - mouthRect.width / 3 , y: mouthRect.minY + smileOffset)
            
            let path  = UIBezierPath()
            path.move(to: start)
            path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
            path.lineWidth = lineWidth
            return path
            
        }
        
        
        private func pathForBrow(eye: Eye) -> UIBezierPath
        {
            var tilt = eyeBrowTilt
            switch eye {
            case .Left:
                tilt *= -1.0
            case .Right:
                break
            }
            
            var borowCenter = getEyeCenter(eye: eye)
            borowCenter.y -=  skullRadius / Ratios.SkullRadiosToBrowOffset
            let eyeRadius = skullRadius / Ratios.SkullRadiosToEyeRadius
            let tiltOffset = CGFloat(max (-1, min(tilt,1))) * eyeRadius / 2
            let browStart = CGPoint(x: borowCenter.x - eyeRadius, y: borowCenter.y - tiltOffset)
            let browEnd = CGPoint(x: borowCenter.x + eyeRadius, y: borowCenter.y + tiltOffset)
            let path = UIBezierPath()
            path.move(to: browStart)
            path.addLine(to: browEnd)
            path.lineWidth = lineWidth
            return path
            
        }
        
        
        
        
        override func draw(_ rect: CGRect)
            
        {
            color.set()
            pathForCircleCenteredAtPoint(midPoint: skullCenter, withRadius: skullRadius).stroke()
            pathForEye(eye: .Left).stroke()
            pathForEye(eye: .Right).stroke()
            pathForBrow(eye: .Left).stroke()
            pathForBrow(eye: .Right).stroke()
            pathForMouth().stroke()
        }
        
        
    }
