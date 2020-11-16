//
//  NetworkService.swift
//  DigitalMediaHubRecruitmentTask
//
//  Created by Krystian Paszek on 16/11/2020.
//

import Foundation
import PromiseKit
import PMKFoundation

class NetworkService: NetworkServiceProtocol {

    func fetchFullProgramInfo() -> Promise<[Station]> {
        let url = URL(string: "https://www.antenne.com/services/program-info/live/antenne")!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970

        return firstly {
            URLSession.shared.dataTask(.promise, with: url).validate()
        }.map {
            try decoder.decode([Station].self, from: $0.data)
        }
    }

    func fetchProgramInfo(forProgramNamed programName: String) -> Promise<Station> {
        return firstly {
            fetchFullProgramInfo()
        }.compactMap {
            $0.first(where: { $0.name == programName })
        }
    }

}
