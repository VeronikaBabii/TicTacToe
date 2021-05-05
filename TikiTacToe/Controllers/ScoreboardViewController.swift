//
//  ScoreboardViewController.swift
//  TikiTacToe
//
//  Created by Pro on 03.02.2021.
//

import UIKit

class ScoreboardViewController: UIViewController {
    
    @IBOutlet weak var playerBestScore: UILabel!
    @IBOutlet weak var machineBestScore: UILabel!
    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    
    @IBOutlet weak var soundButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        let img = UserDefaults.standard.object(forKey: "sound") as? String ?? "1"
        soundButton.setImage(UIImage(named: img), for: .normal)
        
        playerBestScore.text = "\(UserDefaults.standard.integer(forKey: "playerBestScore"))"
        machineBestScore.text = "\(UserDefaults.standard.integer(forKey: "machineBestScore"))"
        
        // archivements
        if UserDefaults.standard.integer(forKey: "arch1") == 1 {
            image1.alpha = 0.5
            label1.alpha = 0.5
        }
        
        if UserDefaults.standard.integer(forKey: "arch2") == 1 {
            image2.alpha = 0.5
            label2.alpha = 0.5
        }
        
        if UserDefaults.standard.integer(forKey: "arch3") == 1 {
            image3.alpha = 0.5
            label3.alpha = 0.5
        }
    }
    
    @IBAction func stopOrPlayMusicTapped(_ sender: UIButton) {
        
        if sender.image(for: .normal) == UIImage(named: "1") {
            sender.setImage(UIImage(named: "0"), for: .normal)
            UserDefaults.standard.setValue("0", forKey: "sound")
            
            DispatchQueue.main.async {
                BackSound.sharedInstance().pauseBGMusic()
            }
            
        } else if sender.image(for: .normal) == UIImage(named: "0") {
            
            sender.setImage(UIImage(named: "1"), for: .normal)
            UserDefaults.standard.setValue("1", forKey: "sound")
            
            if UserDefaults.standard.object(forKey: "play") as? String ?? "0"  == "0" {
                    BackSound.sharedInstance().playBGMusic()
                    UserDefaults.standard.set("1", forKey: "play")
            } else {
                DispatchQueue.main.async {
                    BackSound.sharedInstance().resumeBGMusic()
                }
            }
        }
    }
    
    @IBAction func shuffleMusicTapped(_ sender: UIButton) {
        BackSound.sharedInstance().playBGMusic()
    }
}
