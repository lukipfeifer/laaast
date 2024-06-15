//
//  DisplayCurveView.swift
//  laaast
//
//  Created by Matthias Meissen on 15.06.24.
//

import SwiftUI

struct RecordingView: View {
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
            
            Spacer()
            
            VStack {
                Button("Delete Recording") {
                    deleteRecording(id: selectedRecordingID)
                }
                .disabled(selectedRecordingID == nil)
                .padding(.bottom)
                
                Button("Delete All Recordings") {
                    deleteAllRecordings()
                }
            }
            .padding()
            .onAppear {
                loadRecordingIDs()
            }
        }
    }
    
    private func loadRecordingIDs() {
        let recordings = UserDefaults.standard.dictionary(forKey: "savedRecordings") as? [String: Data] ?? [:]
        recordingIDs = Array(recordings.keys).sorted(by: >)
    }
    
    private func loadRecording(id: String?) {
        guard let id = id else { return }
        if let recordings = UserDefaults.standard.dictionary(forKey: "savedRecordings") as? [String: Data],
           let savedData = recordings[id],
           let loadedEvents = try? JSONDecoder().decode([TouchEvent].self, from: savedData) {
            self.touchEvents = loadedEvents
        }
    }
    
    private func deleteRecording(id: String?) {
        guard let id = id else { return }
        var recordings = UserDefaults.standard.dictionary(forKey: "savedRecordings") as? [String: Data] ?? [:]
        recordings.removeValue(forKey: id)
        UserDefaults.standard.set(recordings, forKey: "savedRecordings")
        loadRecordingIDs()
        touchEvents = []
    }
    
    private func deleteAllRecordings() {
        UserDefaults.standard.removeObject(forKey: "savedRecordings")
        recordingIDs.removeAll()
        touchEvents = []
    }
}

struct RecordingView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingView()
    }
}

