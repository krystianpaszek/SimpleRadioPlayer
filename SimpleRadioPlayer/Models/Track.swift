//
//  Track.swift
//  SimpleRadioPlayer
//
//  Created by Krystian Paszek on 16/11/2020.
//

import Foundation

struct Track: Decodable {
    let id: Int
    let creationTime: Date
    let title: String
    let artist: String
    let cover: URL?

    enum CodingKeys: String, CodingKey {
        case id, creationTime, title, artist
        case cover = "itunesCoverMedium"
    }
}
