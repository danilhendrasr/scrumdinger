//
//  ErrorWrapper.swift
//  ScrumDinger
//
//  Created by Danil Hendra Suryawan on 21/11/24.
//
import Foundation

struct ErrorWrapper: Identifiable {
    let id: UUID
    let error: Error
    let guidance: String

    init(id: UUID = UUID(), error: Error, guidance: String) {
        self.id = id
        self.error = error
        self.guidance = guidance
    }
}
