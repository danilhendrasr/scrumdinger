//
//  MeetingActivityAttributes.swift
//  Scrumdinger
//
//  Created by Danil Hendra Suryawan on 27/11/24.
//

import ActivityKit

struct MeetingActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var secondsElapsed: Int
        var secondsRemaining: Int
        var speaker: String
    }

    var name: String
}
