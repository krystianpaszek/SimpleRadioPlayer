//
//  NetworkServiceProtocol.swift
//  SimpleRadioPlayer
//
//  Created by Krystian Paszek on 16/11/2020.
//

import Foundation
import PromiseKit

protocol NetworkServiceProtocol {
    func fetchFullProgramInfo() -> Promise<[Station]>
    func fetchProgramInfo(forProgramNamed programName: String) -> Promise<Station>
}
