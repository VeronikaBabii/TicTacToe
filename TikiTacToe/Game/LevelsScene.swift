//
//  Levels.swift
//  TikiTacToe
//
//  Created by Pro on 26.02.2021.
//

import SpriteKit

class LevelsScene: SKScene {
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        setup()
    }
    
    func setup() {
        
        var winsArr = UserDefaults.standard.array(forKey: "winsArr") as? [Int] ?? []
        print("wins array is \(winsArr)")
        
        // archivements
        let completed = UserDefaults.standard.integer(forKey: "completedLevel")
        
        // arch 1 - complete all levels
        if completed == 9 {
            UserDefaults.standard.setValue(1, forKey: "arch1")
            print("hello arch 1")
        }
        
        // arch 2 - win 3 levels in a row
        var counter = 0
        for elem in winsArr {
            if elem == 1 { counter += 1 }
            else { counter = 0 }
        }
        if counter == 3 { UserDefaults.standard.setValue(1, forKey: "arch2"); print("hello arch 2") }
        
        // arch 3 - beat tiki idol
        if winsArr.count >= 9 {
            if winsArr[8] == 1 {
                UserDefaults.standard.setValue(1, forKey: "arch3")
                print("hello arch 3")
            }
        }
        
        // set background behind all other elements
        let back = self.childNode(withName: "BackSpriteNode") as? SKSpriteNode
        back?.zPosition = -1
        
        // levels
        guard let level1 = self.childNode(withName: "1LevelSpriteNode") as? SKSpriteNode else { print("error level 1"); return }
        guard let level2 = self.childNode(withName: "2LevelSpriteNode") as? SKSpriteNode else { print("error level 2"); return }
        guard let level3 = self.childNode(withName: "3LevelSpriteNode") as? SKSpriteNode else { print("error level 3"); return }
        guard let level4 = self.childNode(withName: "4LevelSpriteNode") as? SKSpriteNode else { print("error level 4"); return }
        guard let level5 = self.childNode(withName: "5LevelSpriteNode") as? SKSpriteNode else { print("error level 5"); return }
        guard let level6 = self.childNode(withName: "6LevelSpriteNode") as? SKSpriteNode else { print("error level 6"); return }
        guard let level7 = self.childNode(withName: "7LevelSpriteNode") as? SKSpriteNode else { print("error level 7"); return }
        guard let level8 = self.childNode(withName: "8LevelSpriteNode") as? SKSpriteNode else { print("error level 8"); return }
        guard let level9 = self.childNode(withName: "9LevelSpriteNode") as? SKSpriteNode else { print("error level 9"); return }
        
        let completedLevel = UserDefaults.standard.integer(forKey: "completedLevel")
        print("completed \(completedLevel)")
        
        if completedLevel == 9 {
            winsArr = []
            UserDefaults.standard.setValue(nil, forKey: "winsArr")
        }
        
        switch completedLevel {
        case 1:
            setCurrImg(level2, 2)
            level2.alpha = 1
        case 2:
            setCurrImg(level3, 3)
            level3.alpha = 1
        case 3:
            setCurrImg(level4, 4)
            level4.alpha = 1
        case 4:
            setCurrImg(level5, 5)
            level5.alpha = 1
        case 5:
            setCurrImg(level6, 6)
            level6.alpha = 1
        case 6:
            setCurrImg(level7, 7)
            level7.alpha = 1
        case 7:
            setCurrImg(level8, 8)
            level8.alpha = 1
        case 8:
            setCurrImg(level9, 9)
            level9.alpha = 1
        default:
            setCurrImg(level1, 1)
            level1.alpha = 1
        }
        
        if winsArr.count >= 1 {
            if winsArr[0] == 1 {
                setWinImg(level1, 1)
            } else if winsArr[0] == 0 {
                setLoseImg(level1, 1)
            }
        }
        
        if winsArr.count >= 2 {
            if winsArr[1] == 1 {
                setWinImg(level2, 2)
            } else if winsArr[1] == 0 {
                setLoseImg(level2, 2)
            }
        }
        
        if winsArr.count >= 3 {
            if winsArr[2] == 1 {
                setWinImg(level3, 3)
            } else if winsArr[2] == 0 {
                setLoseImg(level3, 3)
            }
        }
        
        if winsArr.count >= 4 {
            if winsArr[3] == 1 {
                setWinImg(level4, 4)
            } else if winsArr[3] == 0 {
                setLoseImg(level4, 4)
            }
        }
        
        if winsArr.count >= 5 {
            if winsArr[4] == 1 {
                setWinImg(level5, 5)
            } else if winsArr[4] == 0 {
                setLoseImg(level5, 5)
            }
        }
        
        if winsArr.count >= 6 {
            if winsArr[5] == 1 {
                setWinImg(level6, 6)
            } else if winsArr[5] == 0 {
                setLoseImg(level6, 6)
            }
        }
        
        if winsArr.count >= 7 {
            if winsArr[6] == 1 {
                setWinImg(level7, 7)
            } else if winsArr[6] == 0 {
                setLoseImg(level7, 7)
            }
        }
        
        if winsArr.count >= 8 {
            if winsArr[7] == 1 {
                setWinImg(level8, 8)
            } else if winsArr[7] == 0 {
                setLoseImg(level8, 8)
            }
        }
        
        if winsArr.count == 9 {
            if winsArr[8] == 1 {
                setWinImg(level9, 9)
            } else if winsArr[8] == 0 {
                setLoseImg(level9, 9)
            }
        }
        
        if winsArr.count > 9 {
            
            setCurrImg(level1, 1)
            level1.alpha = 1
        }
    }
    
    func setCurrImg(_ node: SKSpriteNode, _ imgNum: Int) {
        node.texture = SKTexture(imageNamed: "image\(imgNum)h")
    }
    
    func setWinImg(_ node: SKSpriteNode, _ levelNum: Int) {
        node.texture = SKTexture(imageNamed: "\(levelNum)w")
    }
    
    func setLoseImg(_ node: SKSpriteNode, _ levelNum: Int) {
        node.texture = SKTexture(imageNamed: "\(levelNum)l")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let completedLevel = UserDefaults.standard.integer(forKey: "completedLevel")
        
        for touch in touches {
            let location = touch.location(in: self)
            let selectedNode = self.atPoint(location)
            
            if let name = selectedNode.name {
                
                if        name == Consts.level1 && completedLevel == 0 {
                    goToGame()
                } else if name == Consts.level2 && completedLevel == 1 {
                    goToGame()
                } else if name == Consts.level3 && completedLevel == 2 {
                    goToGame()
                } else if name == Consts.level4 && completedLevel == 3 {
                    goToGame()
                } else if name == Consts.level5 && completedLevel == 4 {
                    goToGame()
                } else if name == Consts.level6 && completedLevel == 5 {
                    goToGame()
                } else if name == Consts.level7 && completedLevel == 6 {
                    goToGame()
                } else if name == Consts.level8 && completedLevel == 7 {
                    goToGame()
                } else if name == Consts.level9 && completedLevel == 8 {
                    goToGame()
                } else if name == Consts.level1 && completedLevel == 9 {
                    goToGame()
                }
            }
        }
    }
    
    func goToGame() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "gameVC")
        vc.view.frame = (self.view?.frame)!
        vc.view.layoutIfNeeded()
        
        UIView.transition(with: self.view!,
                          duration: 0.01,
                          options: .transitionCrossDissolve,
                          animations: { self.view?.window?.rootViewController = vc },
                          completion: { completed in })
    }
    
    override func update(_ currentTime: TimeInterval) {}
    
}

