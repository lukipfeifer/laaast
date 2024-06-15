//
//  DisplayCurveView.swift
//  laaast
//
//  Created by Matthias Meissen on 15.06.24.
//

import SwiftUI

struct DisplayCurveView: View {
    @State private var touchEvents: [TouchEvent] = []
    @State private var recordingIDs: [String] = []
    @State private var selectedRecordingID: String?
    
    var body: some View {
        VStack {
            Picker("Select Recording", selection: $selectedRecordingID) {
                ForEach(recordingIDs, id: \.self) { id in
                    Text(id).tag(id as String?)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .onChange(of: selectedRecordingID) { newID in
                loadRecording(id: newID)
            }
            
            TouchCurveView(touchEvents: touchEvents, maxWidth: UIScreen.main.bounds.width, maxHeight: 200, yScaleFactor: 0.5)
                .padding()
                .onAppear {
                    loadRecordingIDs()
                }
        }
    }
    
    private func loadRecordingIDs() {
        let recordings = UserDefaults.standard.dictionary(forKey: "savedRecordings") as? [String: Data] ?? [:]
        recordingIDs = Array(recordings.keys)
    }
    
    private func loadRecording(id: String?) {
        guard let id = id else { return }
        if let recordings = UserDefaults.standard.dictionary(forKey: "savedRecordings") as? [String: Data],
           let savedData = recordings[id],
           let loadedEvents = try? JSONDecoder().decode([TouchEvent].self, from: savedData) {
            self.touchEvents = loadedEvents
        }
    }
}

struct DisplayCurveView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayCurveView()
    }
}

