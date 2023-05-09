//
//  UIGraphWavesView.swift
//  TicTacToe
//
//  Created by Cell on 08.05.2023.
//

import UIKit;
import AVFoundation;

class UIGraphWavesView: UIControl {
    
    private var _ClipLayer: CAShapeLayer? = nil;
    private var _ClipPath: UIBezierPath? = nil;
    
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
        
        let backgroundLayer = CAShapeLayer();
        
        backgroundLayer.path = path.cgPath;
        
        backgroundLayer.lineWidth = 3;
        backgroundLayer.lineCap = .round;
        backgroundLayer.strokeColor = UIColor.systemGray.cgColor;
        
        let foregroundLayer = CAShapeLayer();
        foregroundLayer.path = path.cgPath;
        foregroundLayer.lineWidth = 3;
        foregroundLayer.lineCap = .round;
        foregroundLayer.strokeColor = UIColor.systemBlue.cgColor;
        
        let animation = CABasicAnimation();
        animation.keyPath = "strokeEnd";
        animation.fromValue = 0.0;
        animation.toValue = 1.0;
        animation.duration = 0.5;
        
        backgroundLayer.add(animation, forKey: "anim");
        foregroundLayer.add(animation, forKey: "anim");
        
        _ClipLayer = CAShapeLayer();
        _ClipPath = UIBezierPath(rect: CGRect(x: 50, y: 0, width: 50, height: s.height));
        _ClipLayer!.path = _ClipPath!.cgPath;
        
        layer.addSublayer(backgroundLayer);
        layer.addSublayer(foregroundLayer);
        foregroundLayer.mask = _ClipLayer;
    }
}


extension UIGraphWavesView {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return;
        }
        
        let point = touch.location(in: self);
        _ClipPath?.removeAllPoints();
        
        _ClipPath?.move(to: CGPoint(x: point.x-25, y: 0)); // the top-left corner
        _ClipPath?.addLine(to: CGPoint(x: point.x+25, y: 0)); // to the top-right corner
        _ClipPath?.addLine(to: CGPoint(x: point.x+25, y: bounds.height)); // to the bottom-right corner
        _ClipPath?.addLine(to: CGPoint(x: point.x-25, y: bounds.height)); // to the bottom-left corner
        
        _ClipLayer?.path = _ClipPath?.cgPath;
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}
