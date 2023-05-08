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
    
    private var _IndexRow = 0;
    private var _IndexCol = 0;
    
    private var _NumberOfChoices:UInt8 = 0;
    
    private var _IsCrossPlayer = true;
    
    private var _isActive:Bool = true;
    
    var delegate: UITicTacToeDelegate? = nil;
    
    var padding: Padding = Padding() {
        didSet {
            _GridWidth = bounds.width - padding.left - padding.right;
            _GridHeight = bounds.height - padding.top - padding.bottom;
            _CellWidth = _GridWidth / 3;
            _CellHeight = _GridHeight / 3;
        }
    };
    
    var gridColor: UIColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0) {
        didSet {
            guard let layers = layer.sublayers else {
                return;
            }
            (layers[0] as? CAShapeLayer)?.strokeColor = gridColor.cgColor;
        }
    };
    
    var crossColor: UIColor = UIColor.green {
        didSet {
            guard let layers = layer.sublayers else {
                return;
            }
                        
        }
    };
    var circleColor: UIColor = UIColor.red;
    
    private func initial() {
        padding = Padding(left: 8, top: 8, right: 8, bottom: 8);
    }
    
    private func defineWinner() {
        delegate?.onEndGameSession();
        if _IsCrossPlayer {
            delegate?.onCrossPlayerWins();
        } else {
            delegate?.onCirclePlayerWins();
        }
    }
    
    private func randomPosition() {
        let posX = Int.random(in: 0..<_Grid.count);
        let posY = Int.random(in: 0..<_Grid.count);
        print("randomPosition: CHECKING POSITION:");
        if _Grid[posX][posY] == 0 {
            _Grid[posX][posY] = -1;
            _IndexCol = posX;
            _IndexRow = posY;
            print("randomPosition:",posX,posY);
            return;
        }
        randomPosition();
    }
    
    func reset(isAnimatable: Bool = true) {
        let lineWidthAnim = CABasicAnimation();
        
        lineWidthAnim.keyPath = "lineWidth";
        lineWidthAnim.fromValue = 3;
        lineWidthAnim.toValue = 0;
        lineWidthAnim.duration = 0.4;
        
        if let sublayers = layer.sublayers {
            for i in 1..<sublayers.count {
                let layer = sublayers[i] as? CAShapeLayer;
                layer?.add(lineWidthAnim, forKey: "line");
                layer?.lineWidth = 0;
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.layer.sublayers = nil;
            self.setNeedsDisplay();
            for i in 0..<self._Grid.count {
                for j in 0..<self._Grid.count {
                    self._Grid[i][j] = 0;
                }
            }
            self._NumberOfChoices = 0;
            self._isActive = true;
        });
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
        
        if layer.sublayers == nil {
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
            _GridLayer.strokeColor = gridColor.cgColor;
            layer.addSublayer(_GridLayer);
            return;
        }
        
        let factorX = CGFloat(_IndexCol) + 0.25;
        let factorY = CGFloat(_IndexRow) + 0.25;
        
        let bx = _CellWidth * factorX;
        let by = _CellHeight * factorY;
        
        let ex = _CellWidth * (factorX + 0.50);
        let ey = _CellHeight * (factorY + 0.50);
        
        if _IsCrossPlayer {
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
            crossLayer.strokeColor = crossColor.cgColor;
         
            let crossAnimation = CAKeyframeAnimation();
            
            crossAnimation.keyPath = "strokeEnd";
            crossAnimation.values =   [0, 0.55, 0.7, 1];
            crossAnimation.keyTimes = [0, 0.75, 0.85, 1];
            crossAnimation.duration = 0.5;
            
            crossLayer.add(crossAnimation, forKey: "crossAnim");
            layer.addSublayer(crossLayer);
            
            _IsCrossPlayer = false;
            return;
        }
        
        let center = CGPoint(x: _CellWidth * (factorX + 0.25),
                             y: _CellHeight * (factorY + 0.25));
        
        let circlePath = UIBezierPath(arcCenter: center, radius: _CellWidth*0.25, startAngle: 0, endAngle: .pi * 2, clockwise: false);
        
        let circleLayer = CAShapeLayer();
        
        circleLayer.path = circlePath.cgPath;
        circleLayer.lineCap = .round;
        circleLayer.lineWidth = 3;
        circleLayer.fillColor = UIColor.clear.cgColor;
        circleLayer.strokeColor = circleColor.cgColor;
        
        let circleAnimation = CAKeyframeAnimation();
        circleAnimation.keyPath = "strokeEnd";
        circleAnimation.values =   [0, 0.5, 0.7, 0.8, 0.95, 0.98, 1];
        circleAnimation.keyTimes = [0, 0.5, 0.7, 0.8, 0.9, 0.9, 1];
        circleAnimation.duration = 0.4;
                
        circleLayer.add(circleAnimation, forKey: "circleAnim");
                
        layer.addSublayer(circleLayer);
        
        _IsCrossPlayer = true;
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
        
        if !_isActive {
            return;
        }
        
        _isActive = false;
        
        guard let touch = touches.first else {
            _isActive = true;
            return;
        }
        
        let end = touch.location(in: self);
        
        if end.x < 0 || end.y < 0 || end.x > _GridWidth || end.y > _GridHeight {
            print("TOUCH_END: OUT OF BOUNDS");
            _isActive = true;
            return;
        }
        
        _IndexCol = Int(end.x / _CellWidth);
        _IndexRow = Int(end.y / _CellHeight);
        
        print("TOUCH_END: MAP:",_Grid);
        
        if _Grid[_IndexRow][_IndexCol] != 0 {
            print("TOUCH_END: IT'S BUSY CELL", _IndexRow, _IndexCol);
            _isActive = true;
            return;
        }
        
        let player:Int8 = _IsCrossPlayer ? 1 : -1;
        
        print("PLAYER:",player);
        
        _Grid[_IndexRow][_IndexCol] = player;
        
        var diagonal = 0;
        
        var isContinue = true;
        
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
                isContinue = false;
                break;
            }
        }
        
        if diagonal == 3 {
            print("WINNNNNEEERRR!!!");
            defineWinner();
            isContinue = false;
        }
        
        if isContinue && _NumberOfChoices >= 8 {
            delegate?.onEndGameSession();
            delegate?.onDraw();
        }
        
        if isContinue {
            _NumberOfChoices += 1;
            _isActive = true;
        }
        
        print("TOUCH_END:",_IndexRow,_IndexCol,end);
        setNeedsDisplay();
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
