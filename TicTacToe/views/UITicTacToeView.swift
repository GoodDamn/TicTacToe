//
//  UITicTacToeView.swift
//  TicTacToe
//
//  Created by Cell on 06.05.2023.
//

import UIKit;

class UITicTacToeView: UIControl {
    
    private var _Grid:[[Int8]] = Array(
        repeating: Array(repeating: 0, count: 3),
        count: 3);
    
    private let _GridLayer = CAShapeLayer();
    private var _BeginPoint:CGPoint = .zero;
    
    private var _GridWidth: CGFloat!;
    private var _GridHeight: CGFloat!;
    
    private var _CellWidth: CGFloat!;
    private var _CellHeight: CGFloat!;
    
    private var indexRow = 0;
    private var indexCol = 0;
    
    private var _IsSecondPlayer = false;
    
    var delegate: UITicTacToeDelegate? = nil;
    
    var padding: Padding = Padding() {
        didSet {
            _GridWidth = bounds.width - padding.left - padding.right;
            _GridHeight = bounds.height - padding.top - padding.bottom;
            _CellWidth = _GridWidth / 3;
            _CellHeight = _GridHeight / 3;
        }
    };
    
    var gridColor: CGColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor;
    
    var crossColor: CGColor = UIColor.green.cgColor;
    var circleColor: CGColor = UIColor.red.cgColor;
    
    private func initial() {
        padding = Padding(left: 8, top: 8, right: 8, bottom: 8);
    }
    
    private func defineWinner() {
        if _IsSecondPlayer {
            delegate?.onCirclePlayerWin();
        } else {
            delegate?.onCrossPlayerWin();
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        initial();
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder);
        initial();
    }
    
    override func draw(_ rect: CGRect) {
        
        let path = UIBezierPath();
        
        UIBezierPath.addLine(x1: _CellWidth+padding.left,
                y1: padding.top,
                x2: _CellWidth,
                y2: _GridHeight, path);
        
        UIBezierPath.addLine(x1: _CellWidth * 2,
                y1: padding.top,
                x2: _CellWidth * 2,
                y2: _GridHeight, path);
    
        UIBezierPath.addLine(x1: padding.left,
                y1: _CellHeight,
                x2: _GridWidth,
                y2: _CellHeight, path);
        
        UIBezierPath.addLine(x1: padding.left,
                y1: _CellHeight * 2,
                x2: _GridWidth,
                y2: _CellHeight * 2, path)
        
        _GridLayer.path = path.cgPath;
        _GridLayer.lineCap = .round;
        _GridLayer.lineWidth = 2;
        _GridLayer.strokeColor = gridColor;
        
        if layer.sublayers == nil {
            layer.addSublayer(_GridLayer);
            return;
        }
        
        
        
        let factorX = CGFloat(indexCol) + 0.25;
        let factorY = CGFloat(indexRow) + 0.25;
        
        let bx = _CellWidth * factorX;
        let by = _CellHeight * factorY;
        
        let ex = _CellWidth * (factorX + 0.50);
        let ey = _CellHeight * (factorY + 0.50);
        
        if _IsSecondPlayer {
            let crossLayer = CAShapeLayer();
            let crossPath = UIBezierPath();
            
            UIBezierPath.addLine(x1: bx,
                                 y1: by,
                                 x2: ex,
                                 y2: ey, crossPath);
            
            UIBezierPath.addLine(x1: bx,
                                 y1: ey,
                                 x2: ex,
                                 y2: by, crossPath);
            
            crossLayer.path = crossPath.cgPath;
            crossLayer.lineCap = .round;
            crossLayer.lineWidth = 3;
            crossLayer.strokeColor = crossColor;
            layer.addSublayer(crossLayer);
            return;
        }
        
        let center = CGPoint(x: _CellWidth * (factorX + 0.25),
                             y: _CellHeight * (factorY + 0.25));
        
        let circlePath = UIBezierPath(arcCenter: center, radius: _CellWidth*0.25, startAngle: 0, endAngle: .pi * 2, clockwise: false);
        
        let circleLayer = CAShapeLayer();
        
        circleLayer.path = circlePath.cgPath;
        circleLayer.lineCap = .round;
        circleLayer.lineWidth = 3;
        circleLayer.fillColor = UIColor(white: 0, alpha: 0).cgColor;
        circleLayer.strokeColor = circleColor;
        
        layer.addSublayer(circleLayer);
        
    }
    
}

extension UITicTacToeView {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else {
            return;
        }
        
        _BeginPoint = touch.location(in: self);
        
        print("TOUCH BEGIN:",_BeginPoint);
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else {
            return;
        }
        
        let end = touch.location(in: self);
        
        if end.x < 0 || end.y < 0 || end.x > _GridWidth || end.y > _GridHeight {
            print("TOUCH_END: OUT OF BOUNDS");
            return;
        }
        
        indexCol = Int(end.x / _CellWidth);
        indexRow = Int(end.y / _CellHeight);
        
        print("TOUCH_END: MAP:",_Grid);
        
        if _Grid[indexRow][indexCol] != 0 {
            print("TOUCH_END: IT'S BUSY CELL", indexRow, indexCol);
            return;
        }
        
        let player:Int8 = _IsSecondPlayer ? 1 : -1;
        
        _Grid[indexRow][indexCol] = player;
        
        var diagonal = 0;
        
        // Checking a winner
        for i in 0..<_Grid.count {
            if _Grid[2-i][i] == player || _Grid[i][i] == player {
                diagonal += 1;
            }
            
            // Checking rows and columns
            if (_Grid[i][0] == player &&
                _Grid[i][1] == player &&
                _Grid[i][2] == player)
                ||
                (_Grid[0][i] == player &&
                 _Grid[1][i] == player &&
                 _Grid[2][i] == player)
            {
                print("WINNNNNEEERRR!!! OF THE ROW AND COLUMN");
                defineWinner();
                break;
            }
        }
        
        if diagonal == 3 {
            print("WINNNNNEEERRR!!!");
            defineWinner();
        }
        
        _IsSecondPlayer = !_IsSecondPlayer;
        print("TOUCH_END:",indexRow,indexCol,end);
        setNeedsDisplay();
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}

extension UIBezierPath {
    
    static func addLine(
        x1:CGFloat,
        y1:CGFloat,
        x2:CGFloat,
        y2:CGFloat,
        _ path: UIBezierPath
    ) {
        path.move(to: CGPoint(x: x1, y: y1));
        path.addLine(to: CGPoint(x: x2, y: y2));
    }
    
}
