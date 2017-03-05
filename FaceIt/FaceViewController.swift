//
//  ViewController.swift
//  FaceIt
//
//  Created by Saeid.mhd@gmail on 2/26/17.
//  Copyright © 2017 Saeid mohammadi. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {
    
    var expression = FacialExpression(eyes: .Open , eyeBrows: .Normal , mouth: .Frown){
        didSet{
            updateUI()
        }
    }
    
    @IBOutlet weak var faceView: FaceView! {
        didSet{
            updateUI()
        }
    }
    private var mouthCurvatures = [FacialExpression.Mouth.Frown:-1.0,
                                   .Grin:0.5,
                                   .Smile:1.0,
                                   .Smirk:-0.5,
                                   .Neutral:0.0]
    
    private var eyeBrowTilts = [FacialExpression.EyeBrows.Relaxed:0.5,
                                .Furrowed:-0.5,
                                .Normal:0.0]
    
    private func updateUI(){
        
        switch expression.eyes {
        case .Open:
            faceView.eyeOpen = true
        case .Closed:
            faceView.eyeOpen = false
        case .Squinting:
            faceView.eyeOpen = false
        }
        
        faceView.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
        faceView.eyeBrowTilt = eyeBrowTilts[expression.eyeBrows] ?? 0.0
        
    }
    
}

