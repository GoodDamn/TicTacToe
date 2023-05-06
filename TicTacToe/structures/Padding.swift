//
//  Padding.swift
//  TicTacToe
//
//  Created by Cell on 06.05.2023.
//

import Foundation
import UIKit;

class Padding {
    
    var left: CGFloat;
    var top: CGFloat;
    var right: CGFloat;
    var bottom: CGFloat;
    
    init() {
        left = 0;
        top = 0;
        right = 0;
        bottom = 0;
    }
    
    init(left: CGFloat,
         top: CGFloat,
         right: CGFloat,
         bottom: CGFloat) {
        
        self.left = left;
        self.right = right;
        self.top = top;
        self.bottom = bottom;
        
    }
    
}
