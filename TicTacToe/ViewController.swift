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
        
        mViewTicTacToe.gridColor = UIColor.systemTeal.cgColor;
        mViewTicTacToe.delegate = self;
        mViewTicTacToe.layer.cornerRadius = 15.0;
        mViewTicTacToe.clipsToBounds = true;
        
    }

}

extension ViewController: UITicTacToeDelegate {
    
    func onCirclePlayerWin() {
        mLabel.text = "Circle player win";
    }
    
    func onCrossPlayerWin() {
        mLabel.text = "Cross player win";
    }
}
