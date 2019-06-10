//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Mahesh Chauhan on 27/5/19.
//  Copyright © 2019 Mahesh Chauhan. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    // AVAudioRecorder instance to record the audio.
    var audioRecorder: AVAudioRecorder!

    // Label to display when recording is in progress.
    @IBOutlet var recordingLabel: UILabel!
    // Button to let user stop the recording.
    @IBOutlet var stopRecordingButton: UIButton!
    // Button to let user record the voice.
    @IBOutlet var recordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Let's configure the UI so that initial UI will show appropriate message and stop recording option as disabled.
        configureUI(isRecording: false)
    }
    
    // Action when user will tap on record button.
    @IBAction func recordAudio(_ sender: Any) {
        // As user started the recording, let's update the UI again to that label will show appropriate message and recording option is disabled.
        configureUI(isRecording: true)
        
        // Let's decide where to store the recorded audio file.
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        // Let's decide the files name.
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        // Let's prepare the file path where we want to save the file.
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        // Preparing a audio session.
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        // Let's prepare a audioRecoder instance to record the audio.
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        // Let's start recording.
        audioRecorder.record()
    }
    
    // Action when user will tap on stop recording button.
    @IBAction func stopRecording(_ sender: Any) {
        // As user stopped the recording, let's update the UI again to that label will show appropriate message and stop recording option is disabled.
        configureUI(isRecording: false)
        // Let's tell audio recorder to stop.
        audioRecorder.stop()
        
        // Also let's tell the AVAudioSession that this session is not active now.
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
    }
    
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("Recording was not successful.")
        }
    }
    
    /**
     Configures the UI based on whether the recording is currently going or not.
     - parameter isRecording: Describe whether the recording is currently going on or not.
    */
    func configureUI(isRecording: Bool) {
        recordingLabel.text = isRecording ? "Recording in Progress" : "Tap to Record"
        stopRecordingButton.isEnabled = isRecording
        recordButton.isEnabled = !isRecording
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Let's prepare before launching PlaySoundsViewController.
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }

}

