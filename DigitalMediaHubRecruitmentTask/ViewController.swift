//
//  ViewController.swift
//  DigitalMediaHubRecruitmentTask
//
//  Created by Krystian Paszek on 16/11/2020.
//

import UIKit
import AVFoundation

private let kPlayButtonImage = UIImage(systemName: "play.fill")
private let kPauseButtonImage = UIImage(systemName: "pause.fill")

class ViewController: UIViewController, AVPlayerItemMetadataOutputPushDelegate {

    // MARK: - Properties
    private let player: AVPlayer = {
        let streamURL = URL(string: "https://stream.antenne.com/antenne-nds-80er/mp3-128/iPhoneApp")!
        let player = AVPlayer(url: streamURL)
        return player
    }()

    // MARK: - Outlets
    @IBOutlet weak var playPauseButton: UIButton!

    // MARK: - Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setupMetadataOutput()
        play()
    }

    // MARK: - Setup
    private func setupMetadataOutput() {
        let metadataOutput = AVPlayerItemMetadataOutput()
        metadataOutput.setDelegate(self, queue: .main)
        player.currentItem?.add(metadataOutput)
    }

    // MARK: - Actions
    @IBAction func playPauseButtonTouched(_ sender: UIButton) {
        player.timeControlStatus == .playing ? pause() : play()
    }

    private func play() {
        playPauseButton.setImage(kPauseButtonImage, for: .normal)
        player.play()
    }

    private func pause() {
        playPauseButton.setImage(kPlayButtonImage, for: .normal)
        player.pause()
    }
}

// MARK: - AVPlayerItemMetadataOutputPushDelegate
extension ViewController {
    func metadataOutput(_ output: AVPlayerItemMetadataOutput, didOutputTimedMetadataGroups groups: [AVTimedMetadataGroup], from track: AVPlayerItemTrack?) {
    }
}

