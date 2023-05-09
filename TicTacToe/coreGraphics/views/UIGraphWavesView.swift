//
//  UIGraphWavesView.swift
//  TicTacToe
//
//  Created by Cell on 08.05.2023.
//

import UIKit
class UIGraphWavesView: UIView {
    
    var audioData:Data? = nil {
        didSet {
            setNeedsDisplay();
        }
    };
    
    override init(frame: CGRect) {
        super.init(frame: frame);
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    override func draw(_ rect: CGRect) {
        
        guard let audioData = audioData else {
            print("AUDIO DATA IS NIL");
            return;
        }
        
        layer.sublayers = nil;
        
        let backgroundLayer = CAShapeLayer();
        
        let path = UIBezierPath();
        
        let s = bounds.size;
        
        let duration = audioData.count;//ms
        let n = 80;
        let nf = CGFloat(n);
        
        let offset = duration / n;
        let wLine = s.width / nf;
        
        let midY = s.height / 2;
        
        var offsetPoint = CGPoint(x: wLine, y: midY);
        var linePoint = CGPoint(x: wLine, y: 5);
        
        print(offsetPoint, linePoint);
        
        var analogValue:CGFloat;
        
        for i in 0..<n {
            
            let off = i * offset;
            let arr = audioData.subdata(in: off..<(off+2));
            
            analogValue = CGFloat(0.1)
            
            arr.withUnsafeBytes {
                (shortPtr: UnsafePointer<Int16>) in
                analogValue = analogValue + CGFloat(shortPtr[0]) / CGFloat(UINT16_MAX);
            };
            let delta = offsetPoint.y * analogValue;
            linePoint.y = offsetPoint.y + delta;
            offsetPoint.y -= delta;
            path.move(to: offsetPoint);
            path.addLine(to: linePoint);
            
            offsetPoint.y = midY;
            offsetPoint.x += wLine;
            linePoint.x += wLine;
        }
        
        backgroundLayer.path = path.cgPath;
        
        backgroundLayer.lineWidth = 3;
        backgroundLayer.lineCap = .round;
        backgroundLayer.strokeColor = UIColor.systemTeal.cgColor;
        
        layer.addSublayer(backgroundLayer);
        
    }
}
