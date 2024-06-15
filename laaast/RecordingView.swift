//
//  DisplayCurveView.swift
//  laaast
//
//  Created by Matthias Meissen on 15.06.24.
//

import SwiftUI

struct RecordingView: View {
    @State private var recordings: [(id: String, touchEvents: [TouchEvent])] = []
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(recordings, id: \.id) { recording in
                    VStack(alignment: .leading) {
                        Text(recording.id)
                            .font(.headline)
                        
                        TouchCurveView(touchEvents: recording.touchEvents, maxWidth: UIScreen.main.bounds.width, maxHeight: 100, yScaleFactor: 0.15)

                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                }
            }
            
            Spacer()
            
            VStack {
                Button("Delete All Recordings") {
                    deleteAllRecordings()
                }
                .padding(.bottom)
            }
            .padding()
            .onAppear {
                loadRecordings()
            }
        }
    }
    
    private func loadRecordings() {
        let recordingsDict = UserDefaults.standard.dictionary(forKey: "savedRecordings") as? [String: Data] ?? [:]
        recordings = recordingsDict.compactMap { id, data in
            if let touchEvents = try? JSONDecoder().decode([TouchEvent].self, from: data) {
                return (id: id, touchEvents: touchEvents)
            }
            return nil
        }.sorted(by: { $0.id > $1.id })
    }
    
    private func deleteAllRecordings() {
        UserDefaults.standard.removeObject(forKey: "savedRecordings")
        recordings.removeAll()
    }
}

struct RecordingView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingView()
    }
}

