//
//  RecordSoundsViewController.swift
//  Escandon
//
//  Created by Vatslav on 23/02/15.
//  Copyright (c) 2015 Vatslav. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    //UI Variables
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var stopButtonOutlet: UIButton!
    @IBOutlet weak var recordButtonOutlet: UIButton!
    
    
    // variablers
    var toggleStop = true
    var toggleRecord = true
    var audioRecorder: AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        hiddenStopButton()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "stopRecording") {
            // We create an instance of the view to
            let playSoundsVC: PlaySoundViewController = segue.destinationViewController as PlaySoundViewController
            let data = sender as RecordedAudio // Here the sender is RecordedAudio as well
            playSoundsVC.receivedAudio = data
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any råesources that can be recreated.
    }

    //This @IBAction tells to developers this function is binding to the Interface Builder
    @IBAction func recordAudio(sender: UIButton) {
        //TODO: Record the user's voice
        println("In recordAudio Button")
        hiddenStopButton()
        toggleRecordButton()
        message.hidden = false
        record()
    }

    @IBAction func stopButton(sender: UIButton) {
        message.hidden = true
        hiddenStopButton()
        toggleRecordButton()
        stopAudio()
        
    }
    
    func hiddenStopButton() {
        stopButtonOutlet.hidden = toggleStop;
        toggleStop = !toggleStop;
    }
    
    func toggleRecordButton() {
        toggleRecord = !toggleRecord
        recordButtonOutlet.enabled = toggleRecord
    }
    
    func record() {
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        
        let recordingName = formatter.stringFromDate(currentDateTime) + ".wav"
        let pathArray = [dirPath, recordingName]
        
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print("The file path where the music will be saved: ", filePath)
        
        var session:AVAudioSession = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.meteringEnabled = true
        audioRecorder.delegate = self
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    func stopAudio() {
        print("Audio was saved and stopped")
        self.audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if flag {
        // TODO: Save the recorded audio
        recordedAudio = RecordedAudio()
        recordedAudio.filePathUrl = recorder.url
        recordedAudio.title = recorder.url.lastPathComponent
        // TODO: Move to the next segue
        self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            print("It was a problem saving the audio")
            recordButtonOutlet.enabled = true
        }
    }
    
    
}

