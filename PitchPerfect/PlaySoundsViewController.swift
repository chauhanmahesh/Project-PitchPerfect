//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Mahesh Chauhan on 1/6/19.
//  Copyright © 2019 Mahesh Chauhan. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    // Button to let user play sound as Snail.
    @IBOutlet weak var snailButton: UIButton!
    // Button to let user play sound as Chipmunk.
    @IBOutlet weak var chipmunkButton: UIButton!
    // Button to let user play sound as Rabbit.
    @IBOutlet weak var rabbitButton: UIButton!
    // Button to let user play sound as Vader.
    @IBOutlet weak var vaderButton: UIButton!
    // Button to let user play sound with Echo effect.
    @IBOutlet weak var echoButton: UIButton!
    // Button to let user play sound with Reverb effect.
    @IBOutlet weak var reverbButton: UIButton!
    // Button to let user stop playing the sound effects.
    @IBOutlet weak var stopButton: UIButton!
    
    // To store the recorded audio URL.
    var recordedAudioURL:URL!
    // The audio file which will be played.
    var audioFile:AVAudioFile!
    // AudioEngine to play the audio file.
    var audioEngine:AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    // Enumeration for each audio effect.
    enum ButtonType: Int {
        case slow = 0, fast, chipmunk, vader, echo, reverb
    }
    
    // Action whenever a effect button is pressed.
    @IBAction func playSoundForButton(_ sender: UIButton) {
        // Let's check which button user pressed.
        switch (ButtonType(rawValue: sender.tag)!) {
        case .slow:
            playSound(rate: 0.5)
        case .fast:
            playSound(rate: 1.5)
        case .chipmunk:
            playSound(pitch: 1000)
        case .vader:
            playSound(pitch: -1000)
        case .echo:
            playSound(echo: true)
        case .reverb:
            playSound(reverb: true)
        }
        configureUI(.playing)
    }
    
    // Action whenever stop button is pressed.
    @IBAction func stopButtonPressed(_ sender: AnyObject) {
        stopAudio()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
        // Let's update the contentMode for each button image so that they fit in any screen.
        [snailButton, chipmunkButton, rabbitButton, vaderButton, echoButton, reverbButton].forEach { button in
            button?.imageView?.contentMode = .scaleAspectFit
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.notPlaying)
    }

}
