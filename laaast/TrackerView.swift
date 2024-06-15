//
//  TrackerView.swift
//  laaast
//
//  Created by Matthias Meissen on 14.06.24.
//

import SwiftUI

struct TrackerView: View {
    @State private var touchEvents: [TouchEvent] = []
    @State private var currentTouchPosition: CGPoint?
    @State private var timer: Timer?
    @State private var elapsedTime: TimeInterval = 0

    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack(alignment: .top) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    self.currentTouchPosition = value.location
                                    if self.timer == nil {
                                        self.startLogging()
                                    }
                                }
                        )
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    
                    VStack {
                        Text("Elapsed Time: \(String(format: "%.2f", elapsedTime)) s")
                            .padding()
                            .background(Color.white.opacity(0.7))
                            .cornerRadius(10)
                            .padding(.top, 80)
                            .opacity(touchEvents.isEmpty ? 0 : 1)
                        
                        Text("Tap anywhere to start recording")
                            .foregroundColor(.gray)
                            .opacity(touchEvents.isEmpty ? 1 : 0) // Hide the text once recording starts
                        
                        Spacer()
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            
            Button(action: {
                stopAndSaveRecording()
            }) {
                Text("Stop and Save Recording")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(touchEvents.isEmpty ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.bottom, 20)
            }
            .disabled(touchEvents.isEmpty)
            .padding(.horizontal)
        }
        .onAppear {
            self.resetElapsedTime()
        }
    }
    
    private func startLogging() {
        elapsedTime = 0
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.elapsedTime += 0.1
            
            if let position = self.currentTouchPosition {
                let event = TouchEvent(timestamp: Date(), position: position)
                self.touchEvents.append(event)
            }
        }
    }
    
    private func stopLogging() {
        timer?.invalidate()
        timer = nil
        currentTouchPosition = nil
    }
    
    private func stopAndSaveRecording() {
        stopLogging()
        saveRecording()
    }

    private func saveRecording() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd_HH:mm:ss"
        let recordingID = dateFormatter.string(from: Date())
        
        if let encodedData = try? JSONEncoder().encode(touchEvents) {
            var recordings = UserDefaults.standard.dictionary(forKey: "savedRecordings") as? [String: Data] ?? [:]
            recordings[recordingID] = encodedData
            UserDefaults.standard.set(recordings, forKey: "savedRecordings")
        }
        touchEvents = []  // Clear current events after saving
        resetElapsedTime()
    }

    private func resetElapsedTime() {
        elapsedTime = 0
    }
}

struct TrackerView_Previews: PreviewProvider {
    static var previews: some View {
        TrackerView()
    }
}

