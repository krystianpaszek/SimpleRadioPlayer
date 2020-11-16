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

    // MARK: - Dependencies
    @objc let dataModel = ViewControllerDataModel(networkService: NetworkService())

    // MARK: - Properties
    private let player: AVPlayer = {
        let streamURL = URL(string: "https://stream.antenne.com/antenne-nds-80er/mp3-128/iPhoneApp")!
        let player = AVPlayer(url: streamURL)
        return player
    }()

    private var songNameObservation: NSKeyValueObservation?
    private var artistObservation: NSKeyValueObservation?
    private var albumCoverObservation: NSKeyValueObservation?

    // MARK: - Outlets
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!

    // MARK: - Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        dataModel.reloadData()
        setupObservers()
        setupMetadataOutput()
        play()
    }

    // MARK: - Setup
    private func setupMetadataOutput() {
        let metadataOutput = AVPlayerItemMetadataOutput()
        metadataOutput.setDelegate(self, queue: .main)
        player.currentItem?.add(metadataOutput)
    }

    private func setupObservers() {
        songNameObservation = observe(\.dataModel.songName, options: [.new], changeHandler: { [weak self] (object, change) in
            guard let newValue = change.newValue else { return }
            guard let name = newValue else { return }

            self?.songNameLabel.text = name
        })

        artistObservation = observe(\.dataModel.artist, options: [.new], changeHandler: { [weak self] (object, change) in
            guard let newValue = change.newValue else { return }
            guard let artist = newValue else { return }

            self?.artistNameLabel.text = artist
        })

        albumCoverObservation = observe(\.dataModel.albumCoverURL, options: [.new], changeHandler: { [weak self] (object, change) in
            guard let newValue = change.newValue else { return }
            guard let albumCoverURL = newValue else { return }
            print(albumCoverURL)
        })
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
        dataModel.reloadData()
    }
}

