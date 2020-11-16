//
//  ViewController.swift
//  DigitalMediaHubRecruitmentTask
//
//  Created by Krystian Paszek on 16/11/2020.
//

import UIKit
import AVFoundation
import MediaPlayer
import SDWebImage

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
    @IBOutlet weak var albumCoverImageView: UIImageView!

    // MARK: - Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setupAlbumCoverImageView()
        setupObservers()
        dataModel.reloadData()
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
            updateNowPlaying(key: MPMediaItemPropertyTitle, value: name)
        })

        artistObservation = observe(\.dataModel.artist, options: [.new], changeHandler: { [weak self] (object, change) in
            guard let newValue = change.newValue else { return }
            guard let artist = newValue else { return }

            self?.artistNameLabel.text = artist
            updateNowPlaying(key: MPMediaItemPropertyArtist, value: artist)
        })

        albumCoverObservation = observe(\.dataModel.albumCoverURL, options: [.new], changeHandler: { [weak self] (object, change) in
            guard let newValue = change.newValue else { return }
            guard let albumCoverURL = newValue else { return }

            self?.albumCoverImageView.sd_setImage(with: albumCoverURL) { image, _, _, _ in
                guard let image = image else { return }
                let artwork = MPMediaItemArtwork(boundsSize: image.size, requestHandler: { _ in return image } )
                updateNowPlaying(key: MPMediaItemPropertyArtwork, value: artwork)
            }
        })
    }

    private func setupAlbumCoverImageView() {
        albumCoverImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        albumCoverImageView.sd_imageTransition = .fade
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
        if let item = groups.first?.items.first, let value = item.value {
            debugPrint("///----------")
            debugPrint("NEW SONG METADATA:")
            debugPrint(value)
            debugPrint("///----------")
        }

        dataModel.reloadData()
    }
}

private func updateNowPlaying(key: String, value: Any) {
    let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
    var nowPlayingInfo = nowPlayingInfoCenter.nowPlayingInfo ?? [:]

    nowPlayingInfo[key] = value

    nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
}
