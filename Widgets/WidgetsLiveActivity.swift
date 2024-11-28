//
//  WidgetsLiveActivity.swift
//  Widgets
//
//  Created by Danil Hendra Suryawan on 26/11/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct WidgetsLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MeetingActivityAttributes.self) { context in
            var totalSeconds: Int {
                context.state.secondsElapsed + context.state.secondsRemaining
            }
            
            var progress: Double {
                guard totalSeconds > 0 else { return 1 }
                return Double(context.state.secondsElapsed) / (Double(context.state.secondsElapsed) + Double(context.state.secondsRemaining))
            }
            
            HStack {
                Image("WidgetAppIcon")
                    .resizable()
                    .frame(width: 40, height: 40)
                VStack(alignment: .center) {
                    ProgressView(value: progress)
                    HStack {
                        HStack {
                            Image(systemName: "mic")
                            Text("\(context.state.speaker) is speaking")
                                .font(.caption)
                        }
                        Spacer()
                        Text("\(context.state.secondsElapsed) / \(context.state.secondsRemaining)s")
                            .font(.caption)
                    }
                }
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)
            .padding(.horizontal)

        } dynamicIsland: { context in
            var totalSeconds: Int {
                context.state.secondsElapsed + context.state.secondsRemaining
            }
            
            var progress: Double {
                guard totalSeconds > 0 else { return 1 }
                return Double(context.state.secondsElapsed) / (Double(context.state.secondsElapsed) + Double(context.state.secondsRemaining))
            }
            
            return DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    VStack(alignment: .center) {
                        ProgressView(value: progress)
                        HStack {
                            HStack {
                                Image(systemName: "mic")
                                Text("\(context.state.speaker) is speaking")
                                    .font(.caption)
                            }
                            Spacer()
                            Text("\(context.state.secondsElapsed) / \(context.state.secondsRemaining)s")
                                .font(.caption)
                        }
                    }
                    .padding(.horizontal)
                }
            } compactLeading: {
                HStack {
                    Image(systemName: "mic")
                    Text("\(context.state.speaker)")
                }
            } compactTrailing: {
                ProgressView(value: progress)
                    .progressViewStyle(.circular)
            } minimal: {
                Image(systemName: "mic")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension MeetingActivityAttributes {
    fileprivate static var preview: MeetingActivityAttributes {
        MeetingActivityAttributes(name: "World")
    }
}

extension MeetingActivityAttributes.ContentState {
    fileprivate static var danil: MeetingActivityAttributes.ContentState {
        MeetingActivityAttributes.ContentState(secondsElapsed: 30,
                                               secondsRemaining: 100,
                                               speaker: "Danil")
     }
}

#Preview("Notification",
         as: .content,
         using: MeetingActivityAttributes.preview) {
   WidgetsLiveActivity()
} contentStates: {
    MeetingActivityAttributes.ContentState.danil
}

#Preview("Dynamic Island Compact",
         as: .dynamicIsland(.compact),
         using: MeetingActivityAttributes.preview) {
   WidgetsLiveActivity()
} contentStates: {
    MeetingActivityAttributes.ContentState.danil
}

#Preview("Dynamic Island Expanded",
         as: .dynamicIsland(.expanded),
         using: MeetingActivityAttributes.preview) {
   WidgetsLiveActivity()
} contentStates: {
    MeetingActivityAttributes.ContentState.danil
}
