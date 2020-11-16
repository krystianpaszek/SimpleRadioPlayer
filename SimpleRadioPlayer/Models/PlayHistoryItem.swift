//
//  PlayHistoryItem.swift
//  SimpleRadioPlayer
//
//  Created by Krystian Paszek on 16/11/2020.
//

import Foundation

struct PlayHistoryItem: Decodable {
    let id: Int
    let track: Track
    let start: Date
}
