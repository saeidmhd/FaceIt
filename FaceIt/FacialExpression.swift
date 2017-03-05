//
//  FacialExpression.swift
//  FaceIt
//
//  Created by Saeid.mhd@gmail on 3/5/17.
//  Copyright © 2017 Saeid mohammadi. All rights reserved.
//

import Foundation

struct FacialExpression {
    enum Eyes: Int {
        case Open
        case Closed
        case Squinting
    }
    
    enum EyeBrows: Int {
        case Relaxed
        case Normal
        case Furrowed
        
        func moreRelaxedBrow() -> EyeBrows {
            return EyeBrows (rawValue: rawValue - 1) ?? .Relaxed
        }
        
        func moreFurrwedBrow() -> EyeBrows {
            return EyeBrows (rawValue: rawValue + 1) ?? .Relaxed
        }
    }
    
    enum Mouth: Int {
        
        case Frown
        case Smirk
        case Neutral
        case Grin
        case Smile
        
        func sadderMouth() -> Mouth {
            return Mouth(rawValue: rawValue - 1) ?? .Frown
        }
        
        
        func happierMouth() -> Mouth {
            return Mouth(rawValue: rawValue + 1) ?? .Smile
        }
    }
    var eyes: Eyes
    var eyeBrows: EyeBrows
    var mouth : Mouth
}
