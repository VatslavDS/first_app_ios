//
//  PlaySoundViewController.swift
//  Escandon
//
//  Created by Vatslav on 24/02/15.
//  Copyright (c) 2015 Vatslav. All rights reserved.
//

import UIKit
import AVFoundation


class PlaySoundViewController: UIViewController {

    var player: AVAudioPlayer? = nil
    
    //This variable is for the segue object
    var receivedAudio:RecordedAudio!
    //AudioEngine Object and AudioFile
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("the title \(receivedAudio.title) and the fileURl \(receivedAudio.filePathUrl)")
        if (receivedAudio.filePathUrl != nil) {
            //var filePathUrl = NSURL.fileURLWithPath(filePath)
            self.player = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
            self.player?.enableRate = true
            self.audioEngine = AVAudioEngine()
            audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)

        } else {
            print("The audio wasn't loaded")
        }
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func soundSlow(sender: UIButton) {
        slowAudio()

    }
    @IBAction func soundFast(sender: UIButton) {
        fastAudio()
    }
    @IBAction func stopButton(sender: UIButton) {
        self.player?.stop()
    }
    
    func slowAudio() {
        self.player?.stop()
        self.player?.rate = 0.5
        self.player?.currentTime = 0.0
        self.player?.play()
    }
    
    func fastAudio() {
        self.player?.stop()
        self.player?.rate = 1.5
        self.player?.currentTime = 0.0
        self.player?.play()
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)

    }
    
    @IBAction func playDarthVadeerAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1500)
    }
    func playAudioWithVariablePitch(pitch: Float) {
        self.player?.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
}
