//
//  Station.swift
//  DigitalMediaHubRecruitmentTask
//
//  Created by Krystian Paszek on 16/11/2020.
//

import Foundation

struct Station: Decodable {
    let id: Int
    let name: String
    let playHistories: [PlayHistoryItem]
}
