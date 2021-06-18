//
//  GameViewController.swift
//   TikiTacToe
//
//  Created by Pro on 27.01.2021.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    var scene: GameScene!
    var level: Int!
    let numLevels = 9
    
    var currLevel: Int!
    
    var winsArray = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        winsArray = UserDefaults.standard.array(forKey: "winsArr") as? [Int] ?? []
        print(winsArray)

        let landscape = UIDevice.current.userInterfaceIdiom == .phone
        loadScene(landscape: !landscape)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            return .landscape
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func rotated() {
        if UIDevice.current.orientation.isLandscape { loadScene(landscape: true) }
        else if UIDevice.current.orientation.isPortrait { loadScene(landscape: false) }
    }
    
    private func loadScene(landscape: Bool) {
        
        if UserDefaults.standard.integer(forKey: "completedLevel") == 9 {
            UserDefaults.standard.setValue(0, forKey: "completedLevel")
        }
        
        level = UserDefaults.standard.integer(forKey: "completedLevel") + 1
        print("curr \(level!)")
        
        let skView = self.view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = true
        
        var scene = GameScene(fileNamed: "Portrait")
        scene?.level = level
        
        scene?.scaleMode = .aspectFill
        
        if landscape == true {
            scene = GameScene(fileNamed: "Landscape")
            scene?.scaleMode = .aspectFit
        }
        
        skView.presentScene(scene)
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "levelsVC") as! LevelsViewController
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true, completion: nil)
    }
}
