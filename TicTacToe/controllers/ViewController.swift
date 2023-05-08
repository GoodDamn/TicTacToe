//
//  ViewController.swift
//  TicTacToe
//
//  Created by Cell on 06.05.2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mViewTicTacToe: UITicTacToeView!
    @IBOutlet weak var mLabel: UILabel!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        mViewTicTacToe.gridColor = UIColor.systemTeal;
        mViewTicTacToe.delegate = self;
        mViewTicTacToe.layer.cornerRadius = 15.0;
        mViewTicTacToe.clipsToBounds = true;
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.5, execute: {
            self.mViewTicTacToe.gridColor = UIColor.systemRed;
        });
        
    }
}

extension ViewController: UITicTacToeDelegate {
    
    func onEndGameSession() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.mViewTicTacToe.circleColor = UIColor.random();
            self.mViewTicTacToe.crossColor = UIColor.random();
            self.mViewTicTacToe.reset();
            self.mLabel.text = "Play it";
        })
    }
    
    func onCirclePlayerWins() {
        mLabel.text = "Circle player wins";
    }
    
    func onCrossPlayerWins() {
        mLabel.text = "Cross player wins";
    }
    
    func onDraw() {
        mLabel.text = "Draw";
    }
}

extension CGFloat {
    
    static func randomN() -> CGFloat {
        return CGFloat.random(in: 0..<1.0);
    }
}

extension UIColor {
    
    static func random() -> UIColor {
        return UIColor(red: CGFloat.randomN(),
                       green: CGFloat.randomN(),
                       blue: CGFloat.randomN(),
                       alpha: 1.0);
    }
}
