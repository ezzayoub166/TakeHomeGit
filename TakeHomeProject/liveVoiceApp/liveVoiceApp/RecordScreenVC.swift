//
//  RecordScreenVC.swift
//  liveVoiceApp
//
//  Created by ezz on 30/12/2024.
//

import UIKit
import AVFoundation

class RecordScreenVC: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    // MARK: - UI Elements
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel! // Optional: To display status messages
    
    // MARK: - Audio Properties
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioApplication : AVAudioApplication!
    var audioPlayer: AVAudioPlayer?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupAudioSession()
        setupNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup Methods
    
    /// Sets up the initial state of the UI elements.
    private func setupUI() {
        recordButton.setTitle("Tap to Record", for: .normal)
        playButton.setTitle("Play", for: .normal)
        playButton.isEnabled = false // Initially disabled until a recording exists
        statusLabel.text = "Ready to record."
    }
    
    /// Configures the audio session for recording and playback.
    private func setupAudioSession() {
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            // Set the audio session category, mode, and options.
            try recordingSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
            try recordingSession.setActive(true)
            
            // Request microphone access.
            AVAudioApplication.requestRecordPermission { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.recordButton.isEnabled = true
                        self.statusLabel.text = "Tap to Record."
                        self.recordButton.addTarget(self, action: #selector(self.recordTapped), for: .touchUpInside)
                        self.playButton.addTarget(self, action: #selector(self.playTapped), for: .touchUpInside)
                    } else {
                        self.recordButton.isEnabled = false
                        self.playButton.isEnabled = false
                        self.statusLabel.text = "Microphone access denied. Please enable it in Settings."
                        self.presentPermissionDeniedAlert()
                    }
                }
            }
        } catch {
            // Handle errors in setting up the audio session.
            statusLabel.text = "Failed to set up audio session."
            recordButton.isEnabled = false
            playButton.isEnabled = false
            print("Audio Session setup error: \(error.localizedDescription)")
        }
    }
    
    /// Sets up observers for audio session interruptions.
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleInterruption),
                                               name: AVAudioSession.interruptionNotification,
                                               object: recordingSession)
    }
    
    // MARK: - Button Actions
    
    /// Handles the record button tap event.
    @objc func recordTapped() {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    /// Handles the play button tap event.
    @objc func playTapped() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        // Check if the recording exists
        guard FileManager.default.fileExists(atPath: audioFilename.path) else {
            presentNoRecordingAlert()
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            audioPlayer?.delegate = self
            audioPlayer?.play()
            
            // Update UI to reflect playback status
            playButton.setTitle("Playing...", for: .normal)
            recordButton.isEnabled = false // Disable record button during playback
            statusLabel.text = "Playing recording."
        } catch {
            // Handle the error (e.g., present an alert)
            print("Failed to initialize audio player: \(error.localizedDescription)")
            presentPlaybackErrorAlert()
        }
    }
    
    // MARK: - Recording Methods
    
    /// Starts the audio recording.
    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        // Define the recording settings.
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100, // Changed to standard sample rate
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            // Initialize the audio recorder.
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
            // Update UI to indicate recording has started.
            recordButton.setTitle("Tap to Stop", for: .normal)
            playButton.isEnabled = false // Disable play button during recording
            statusLabel.text = "Recording..."
        } catch {
            // Handle errors in initializing the audio recorder.
            finishRecording(success: false)
            print("Audio Recorder initialization error: \(error.localizedDescription)")
        }
    }
    
    /// Stops the audio recording.
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            recordButton.setTitle("Tap to Re-record", for: .normal)
            playButton.isEnabled = true // Enable play button after successful recording
            statusLabel.text = "Recording finished. Tap Play to listen."
        } else {
            recordButton.setTitle("Tap to Record", for: .normal)
            playButton.isEnabled = false // Disable play button if recording failed
            statusLabel.text = "Recording failed. Please try again."
            presentRecordingFailedAlert()
        }
    }
    
    /// Retrieves the app's documents directory.
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // MARK: - AVAudioRecorderDelegate Methods
    
    /// Called when the audio recorder finishes recording.
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    // MARK: - AVAudioPlayerDelegate Methods
    
    /// Called when the audio player finishes playing.
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            playButton.setTitle("Play", for: .normal)
            recordButton.isEnabled = true // Re-enable record button after playback
            statusLabel.text = "Playback finished."
        } else {
            playButton.setTitle("Play", for: .normal)
            recordButton.isEnabled = true
            statusLabel.text = "Playback failed."
            presentPlaybackErrorAlert()
        }
    }
    
    // MARK: - Permission Denied Alert
    
    /// Presents an alert informing the user that microphone access is denied.
    private func presentPermissionDeniedAlert() {
        let alert = UIAlertController(title: "Microphone Access Denied",
                                      message: "Please enable microphone access in Settings to use this feature.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { _ in
            // Open the app's settings page.
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    /// Presents an alert informing the user that no recording exists.
    private func presentNoRecordingAlert() {
        let alert = UIAlertController(title: "No Recording Found",
                                      message: "Please record audio before attempting to play.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    /// Presents an alert informing the user that playback failed.
    private func presentPlaybackErrorAlert() {
        let alert = UIAlertController(title: "Playback Error",
                                      message: "Unable to play the recording. Please try again.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    /// Presents an alert informing the user that recording failed.
    private func presentRecordingFailedAlert() {
        let alert = UIAlertController(title: "Recording Failed",
                                      message: "There was a problem recording your audio. Please try again.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Audio Session Interruption Handling
    
    /// Handles audio session interruptions (e.g., phone calls).
    @objc func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
            return
        }

        if type == .began {
            // Interruption began, stop recording or playback
            if audioRecorder != nil && audioRecorder.isRecording {
                finishRecording(success: false)
            }
            if audioPlayer != nil && ((audioPlayer?.isPlaying) != nil) {
                audioPlayer?.stop()
                playButton.setTitle("Play", for: .normal)
                recordButton.isEnabled = true
                statusLabel.text = "Playback interrupted."
            }
        } else if type == .ended {
            // Interruption ended, check if should resume
            if let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt {
                let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
                if options.contains(.shouldResume) {
                    // Optionally resume recording or playback
                }
            }
        }
    }
}
