//
//  ContentView.swift
//  ScrumDinger
//
//  Created by Danil Hendra Suryawan on 20/11/24.
//

import ActivityKit
import AVFoundation
import SwiftUI

struct MeetingView: View {
    @Binding var scrum: DailyScrum
    @StateObject var scrumTimer = ScrumTimer()
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State private var isRecording = false
    @State private var isFinished = false
    @State private var activity: Activity<MeetingActivityAttributes>? = nil
    @Environment(\.presentationMode) private var presentationMode

    private var player: AVPlayer { AVPlayer.sharedDingPlayer }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16.0)
                .fill(scrum.theme.mainColor)
            VStack {
                MeetingHeaderView(
                    secondsElapsed: scrumTimer.secondsElapsed,
                    secondsRemaining: scrumTimer.secondsRemaining,
                    theme: scrum.theme)
                MeetingTimerView(
                    speakers: scrumTimer.speakers,
                    isRecording: isRecording,
                    theme: scrum.theme)
                MeetingFooterView(
                    speakers: scrumTimer.speakers,
                    skipAction: scrumTimer.skipSpeaker)
            }
        }
        .padding()
        .foregroundColor(scrum.theme.accentColor)
        .onAppear {
            startScrum()
            startLiveActivity()
        }
        .onDisappear {
            endScrum()
        }
        .onChange(of: scrumTimer.secondsRemaining) { (oldVal, newVal) in
            if newVal == 0 {
                endScrum()
                isFinished = true
            }
            
            updateLiveActivity()
        }
        .alert("Meeting has finished", isPresented: $isFinished) {
            Button("OK") {
                presentationMode.wrappedValue.dismiss()
                stopLiveActivity()
            }
        } message: {
            Text(
                "The meeting has finished. Tap the button below to go back to the previous screen.")
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private func startScrum() {
        scrumTimer.reset(lengthInMinutes: scrum.lengthInMinutes,
                         attendees: scrum.attendees)
        scrumTimer.speakerChangedAction = {
            player.seek(to: .zero)
            player.play()
        }
        speechRecognizer.resetTranscript()
        speechRecognizer.startTranscribing()
        scrumTimer.startScrum()
        isRecording = true
    }

    private func endScrum() {
        scrumTimer.stopScrum()
        speechRecognizer.stopTranscribing()
        let newHistory = History(attendees: scrum.attendees,
                                 transcript: speechRecognizer.transcript)
        scrum.history.insert(newHistory, at: 0)
        isRecording = false
    }
    
    private func startLiveActivity() {
        let attributes = MeetingActivityAttributes(name: "Meeting")
        let state = MeetingActivityAttributes.ContentState(
            secondsElapsed: scrumTimer.secondsElapsed,
            secondsRemaining: scrumTimer.secondsRemaining,
            speaker: scrumTimer.speakers.first(where: { !$0.isCompleted })?.name ?? "No one"
        )
        
        Task {
            do {
                activity = try await Activity<MeetingActivityAttributes>.request(
                    attributes: attributes,
                    content: .init(state: state, staleDate: nil),
                    pushType: nil
                )
            } catch {
                print("Failed to start Live Activity: \(error.localizedDescription)")
            }
        }
    }
    
    private func updateLiveActivity() {
        let state = MeetingActivityAttributes.ContentState(
            secondsElapsed: scrumTimer.secondsElapsed,
            secondsRemaining: scrumTimer.secondsRemaining,
            speaker: scrumTimer.speakers.first(where: { !$0.isCompleted })?.name ?? "No one"
        )
        
        Task {
            await activity?.update(
                ActivityContent<MeetingActivityAttributes.ContentState>(
                    state: state,
                    staleDate: Date.now + 1,
                    relevanceScore: 50
                )
            )
        }
    }
    
    private func stopLiveActivity() {
        let state = MeetingActivityAttributes.ContentState(
            secondsElapsed: 0,
            secondsRemaining: 0,
            speaker: "No one"
        )
        
        Task {
            await activity?.end(
                ActivityContent(state: state, staleDate: nil),
                dismissalPolicy: .immediate
            )
        }
    }
}

#Preview {
    MeetingView(scrum: .constant(DailyScrum.sampleData[0]))
}
