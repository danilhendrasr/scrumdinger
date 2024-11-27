//
//  ErrorView.swift
//  ScrumDinger
//
//  Created by Danil Hendra Suryawan on 21/11/24.
//
import SwiftUI

struct ErrorView: View {
    let errorWrapper: ErrorWrapper
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack {
                Text("An error has occurred!")
                    .font(.title)
                    .padding(.bottom)
                Text(errorWrapper.error.localizedDescription)
                    .font(.headline)
                Text(errorWrapper.guidance)
                    .font(.caption)
                    .padding(.top)
                Spacer()
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Dismiss") {
                        dismiss()
                    }
                }
            }
        }
    }
}

enum SampleError: Error {
    case errorRequired
}

#Preview {
    var wrapper: ErrorWrapper {
        ErrorWrapper(
            error: SampleError.errorRequired,
            guidance: "You can safely ignore this error.")
    }

    ErrorView(errorWrapper: wrapper)
}
