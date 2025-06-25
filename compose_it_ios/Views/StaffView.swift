import SwiftUI

struct StaffView: View {
    let score: MusicScore
    let selectedInstrument: Instrument?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header with score information
            VStack(alignment: .leading, spacing: 8) {
                Text(score.title)
                    .font(.title2)
                    .fontWeight(.bold)
                
                HStack {
                    Text("Key: \(score.keySignature.displayName)")
                    Spacer()
                    Text("Time: \(score.timeSignature.displayName)")
                    Spacer()
                    Text("Tempo: \(score.tempo) BPM")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            
            // Staff lines
            VStack(spacing: 0) {
                ForEach(0..<5) { _ in
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.primary)
                }
            }
            .padding(.horizontal)
            
            // Measures display (placeholder)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(score.measures) { measure in
                        MeasureView(measure: measure, instrument: selectedInstrument)
                    }
                }
                .padding(.horizontal)
            }
            
            Spacer()
        }
        .background(Color(.systemBackground))
    }
}

struct MeasureView: View {
    let measure: MusicScore.Measure
    let instrument: Instrument?
    
    var body: some View {
        VStack(spacing: 4) {
            // Measure number
            Text("\(measure.measureNumber)")
                .font(.caption2)
                .foregroundColor(.secondary)
            
            // Staff lines for this measure
            VStack(spacing: 0) {
                ForEach(0..<5) { _ in
                    Rectangle()
                        .frame(width: 80, height: 1)
                        .foregroundColor(.primary)
                }
            }
            
            // Notes placeholder
            HStack(spacing: 8) {
                ForEach(measure.notes) { note in
                    NoteView(note: note)
                }
            }
            .padding(.top, 4)
        }
        .frame(width: 100)
    }
}

struct NoteView: View {
    let note: MusicScore.Measure.Note
    
    var body: some View {
        VStack(spacing: 2) {
            if note.isRest {
                // Rest symbol placeholder
                Rectangle()
                    .frame(width: 8, height: 12)
                    .foregroundColor(.secondary)
            } else {
                // Note head placeholder
                Circle()
                    .frame(width: 12, height: 12)
                    .foregroundColor(.primary)
                
                // Note stem placeholder
                Rectangle()
                    .frame(width: 2, height: 20)
                    .foregroundColor(.primary)
            }
            
            // Duration indicator
            Text(note.duration.rawValue)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    let sampleScore = MusicScore.generateRandomScore(
        title: "Sample Composition",
        keySignature: KeySignature.commonKeys[0],
        instruments: [Instrument.availableInstruments[0]]
    )
    
    return StaffView(
        score: sampleScore,
        selectedInstrument: Instrument.availableInstruments[0]
    )
} 