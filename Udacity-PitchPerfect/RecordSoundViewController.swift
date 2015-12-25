//
//  RecordSoundViewController.swift
//  Udacity-PitchPerfect
//
//  Created by Rahul Gupta on 23/12/15.
//  Copyright © 2015 Rahul gupta. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var micIcon: UIButton!
    @IBOutlet weak var instructionLbs: UILabel!
    @IBOutlet weak var stopBtn: UIButton!
    
    var recordAudio: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        stopBtn.hidden = true
        micIcon.enabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startRecording(sender: UIButton) {

        stopBtn.hidden = false
        micIcon.enabled = false
        instructionLbs.text = "RECORDING NOW"
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) [0] as String
        /*
        // date formating
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        // set recording file name
        let recordingFileName = formatter.stringFromDate(currentDateTime)+".wav"
        */
        
        let recordingFileName = "myAudio.wav"

        // create an array of all file path and name
        let pathArray = [dirPath, recordingFileName]
        // create a filePath from pathArray
        let filePath = NSURL.fileURLWithPathComponents(pathArray)

        // print filePath in console
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! recordAudio = AVAudioRecorder(URL: filePath!, settings: [:])
        recordAudio.delegate = self
        recordAudio.meteringEnabled = true
        recordAudio.prepareToRecord()
        recordAudio.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            recordedAudio = RecordedAudio()
            recordedAudio.filePathURL = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
        
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else{
            print("Recording was not successful")
            micIcon.enabled = true
            stopBtn.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording"){
            let playSoundsVC: PlaySoundViewController = segue.destinationViewController as! PlaySoundViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }

    @IBAction func stopRecording(sender: UIButton) {

        instructionLbs.text = "Tap To Start Recording"
        recordAudio.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }

}

