//
//  PlaySoundViewController.swift
//  Udacity-PitchPerfect
//
//  Created by Rahul Gupta on 23/12/15.
//  Copyright © 2015 Rahul gupta. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {
    
    var soundToPlay:AVAudioPlayer!
    var audioEngine: AVAudioEngine!
    var receivedAudio: RecordedAudio!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        if let path = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3")
//        {
//            let url = NSURL(fileURLWithPath: path)
//
//        }else{
//            print("Can not find the file specified")
//        }
        
        soundToPlay = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL)
        soundToPlay.prepareToPlay()
        soundToPlay.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathURL)
    }
    
    @IBAction func playSoundSlowly(sender: UIButton){
        playSoundWithVarSpeed(0.5)
    }
    
    @IBAction func playSoundFaster(sender: UIButton){
        playSoundWithVarSpeed(1.5)
    }
    
    @IBAction func stopAllSounds(sender: UIButton) {
        soundToPlay.stop()
    }
    
    @IBAction func playChipmunkSound(sender: UIButton) {
        playSoundWithVariablePitch(1000)
    }
    
    @IBAction func playDwarfSound(sender: UIButton) {
        playSoundWithVariablePitch(-500)
    }
    
    func playSoundWithVariablePitch(pitch: Float){
        soundToPlay.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        soundToPlay.play()
    }
    
    func playSoundWithVarSpeed(rate: Float){
        soundToPlay.stop()
        soundToPlay.rate = rate
        soundToPlay.currentTime = 0.0
        soundToPlay.play()
    }
    
}
