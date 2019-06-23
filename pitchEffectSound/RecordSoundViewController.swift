//
//  RecordSoundViewController.swift
//  pitchEffectSound
//
//  Created by Ahmed on 6/20/19.
//  Copyright © 2019 Ahmed. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController , AVAudioRecorderDelegate {
    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var recordingLable: UILabel!
    
    @IBOutlet weak var recordingButton: UIButton!
    @IBOutlet weak var stopRecrodingButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecrodingButton.isEnabled = false
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @IBAction func recordAudio(_ sender: AnyObject) {
        configureUI(isRecording: true)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    
    
    func configureUI(isRecording: Bool){
        if isRecording == true {
            recordingLable.text = "Recording in progress"
            stopRecrodingButton.isEnabled = true
            recordingButton.isEnabled = false
        }
        else {
            recordingButton.isEnabled = true
            stopRecrodingButton.isEnabled = false
            recordingLable.text = "Tap to Record"
        }
    }
    
    
    @IBAction func stopRecording(_ sender: Any) {
        
        recordingButton.isEnabled = true
        stopRecrodingButton.isEnabled = false
        recordingLable.text = "Tap to Record"
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)

    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
            print("Done recording")
        }
        else {
            print("The recording wasn't successful")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"{
            let  playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudio = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudio
            
        }
        }
    }
    
    


