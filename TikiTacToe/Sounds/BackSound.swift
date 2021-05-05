//
//  BackSound.swift
//  TikiTacToe
//
//  Created by Pro on 04.02.2021.
//

import AVFoundation

class BackSound {
    
    var bgMusic: AVAudioPlayer?
    var soundEffect: AVAudioPlayer?
    
    static func sharedInstance() -> BackSound { return BackSoundInstance }
    
    private func getSongNameFromCatalog() -> String {
        let catalog = ["sound1", "sound2", "sound3", "sound4"]
        let randomSong = catalog.randomElement() ?? "sound1"
        return randomSong  + ".mp3"
    }
    
    func playBGMusic () {
        let fileName = self.getSongNameFromCatalog()
        guard let url = Bundle.main.url(forResource: fileName, withExtension: nil) else { return }
        
        do {
            bgMusic = try AVAudioPlayer(contentsOf: url)
            
        } catch let error as NSError {
            print("BackSound error \(error.localizedDescription)")
            bgMusic = nil
        }
        
        if let backMusic = bgMusic{
            backMusic.numberOfLoops = -1
            backMusic.volume = 0.6
            backMusic.prepareToPlay()
            backMusic.play()
        }
    }
    
    func stopBGMusic() {
        if let backMusic = bgMusic {
            if backMusic.isPlaying { backMusic.stop() }
        }
    }
    
    func pauseBGMusic() {
        if let backMusic = bgMusic {
            if backMusic.isPlaying { backMusic.pause() }
        }
    }
    
    func resumeBGMusic() {
        if let backMusic = bgMusic {
            if !backMusic.isPlaying { backMusic.play() }
        }
    }
    
    func playSoundEffect (_ fileName:String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: nil) else {return}
        
        do {
            soundEffect = try AVAudioPlayer(contentsOf: url)
            
        } catch let error as NSError{
            print("SKTAUDIO ERROR \(error.localizedDescription)")
            soundEffect = nil
        }
        
        if let soundEffect = soundEffect {
            soundEffect.numberOfLoops = 0
            soundEffect.prepareToPlay()
            soundEffect.play()
        }
    }
    
    func stopSoundEffect() {
        if let soundEffect = soundEffect {
            if soundEffect.isPlaying { soundEffect.stop() }
        }
    }
}

private let BackSoundInstance = BackSound()
