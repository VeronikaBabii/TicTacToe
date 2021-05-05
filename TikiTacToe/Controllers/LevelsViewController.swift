//
//  LevelsViewController.swift
//  TikiTacToe
//
//  Created by Pro on 24.02.2021.
//

import UIKit
import SpriteKit

class LevelsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = self.view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = true
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            let scene = LevelsScene(fileNamed: "LevelsPhone")
            scene?.scaleMode = .aspectFill
            skView.presentScene(scene)
            
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            let scene = LevelsScene(fileNamed: "LevelsPad")
            scene?.scaleMode = .aspectFill
            skView.presentScene(scene)
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "menuVC") as! MainMenuViewController
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true, completion: nil)
    }
}
