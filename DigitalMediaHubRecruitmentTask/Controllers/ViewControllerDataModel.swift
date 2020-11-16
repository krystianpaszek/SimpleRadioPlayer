//
//  ViewControllerDataModel.swift
//  DigitalMediaHubRecruitmentTask
//
//  Created by Krystian Paszek on 16/11/2020.
//

import Foundation
import PromiseKit

class ViewControllerDataModel: NSObject {

    static let kStationName = "Z80er"

    // MARK: - Observable properties
    @objc dynamic var songName: String?
    @objc dynamic var artist: String?
    @objc dynamic var albumCoverURL: URL?

    // MARK: - Dependencies
    private let networkService: NetworkServiceProtocol

    // MARK: - Initialization
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    // MARK: - Public functions
    func reloadData() {
        firstly {
            networkService.fetchProgramInfo(forProgramNamed: Self.kStationName)
        }.compactMap { station in
            station.playHistories.first?.track
        }.done { track in
            self.songName = track.title
            self.artist = track.artist
            self.albumCoverURL = track.cover
        }.cauterize()
    }

}
