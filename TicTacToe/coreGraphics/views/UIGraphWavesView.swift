//
//  UIGraphWavesView.swift
//  TicTacToe
//
//  Created by Cell on 08.05.2023.
//

import UIKit
class UIGraphWavesView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame);
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    override func draw(_ rect: CGRect) {
        
        let backgroundLayer = CAShapeLayer();
        
        let path = UIBezierPath();
        
        let s = bounds.size;
        
        let duration = 9000;//ms
        let n = 100;
        let nf = CGFloat(n);
        
        let offset = duration / n;
        
        let wLine = s.width / nf;
        
        var offsetPoint = CGPoint(x: wLine, y: s.height / 2);
        var linePoint = CGPoint(x: wLine, y: 5);
        
        for i in 0..<n {
            path.move(to: offsetPoint);
            linePoint.y = offsetPoint.y + offsetPoint.y * sin(.pi * 2 * 440 * CGFloat(i*offset) / 44100);
            path.addLine(to: linePoint);
            offsetPoint.x += wLine;
            linePoint.x += wLine;
        }
        
        backgroundLayer.path = path.cgPath;
        
        backgroundLayer.lineWidth = 1;
        backgroundLayer.strokeColor = UIColor.systemTeal.cgColor;
        
        layer.addSublayer(backgroundLayer);
        
    }
}
