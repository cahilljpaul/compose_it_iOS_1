import Foundation

struct MusicScore: Identifiable, Codable {
    let id = UUID()
    let title: String
    let keySignature: KeySignature
    let timeSignature: TimeSignature
    let tempo: Int // BPM
    let measures: [Measure]
    let instruments: [Instrument]
    
    enum CodingKeys: String, CodingKey {
        case title, keySignature, timeSignature, tempo, measures, instruments
    }
    
    struct TimeSignature: Codable, Hashable {
        let beats: Int
        let beatType: Int
        
        var displayName: String {
            return "\(beats)/\(beatType)"
        }
    }
    
    struct Measure: Identifiable, Codable {
        let id = UUID()
        let notes: [Note]
        let measureNumber: Int
        
        enum CodingKeys: String, CodingKey {
            case notes, measureNumber
        }
        
        struct Note: Identifiable, Codable {
            let id = UUID()
            let pitch: Instrument.Note
            let duration: Duration
            let isRest: Bool
            
            enum CodingKeys: String, CodingKey {
                case pitch, duration, isRest
            }
            
            enum Duration: String, CaseIterable, Codable {
                case whole = "Whole"
                case half = "Half"
                case quarter = "Quarter"
                case eighth = "Eighth"
                case sixteenth = "Sixteenth"
                case thirtySecond = "Thirty-Second"
                
                var value: Double {
                    switch self {
                    case .whole: return 4.0
                    case .half: return 2.0
                    case .quarter: return 1.0
                    case .eighth: return 0.5
                    case .sixteenth: return 0.25
                    case .thirtySecond: return 0.125
                    }
                }
            }
        }
    }
}

// Score generation utilities
extension MusicScore {
    static func generateRandomScore(
        title: String = "Random Composition",
        keySignature: KeySignature,
        timeSignature: TimeSignature = TimeSignature(beats: 4, beatType: 4),
        tempo: Int = 120,
        numberOfMeasures: Int = 8,
        instruments: [Instrument]
    ) -> MusicScore {
        var measures: [Measure] = []
        
        for measureIndex in 0..<numberOfMeasures {
            let notes = generateRandomNotesForMeasure(
                timeSignature: timeSignature,
                keySignature: keySignature,
                measureNumber: measureIndex + 1
            )
            measures.append(Measure(notes: notes, measureNumber: measureIndex + 1))
        }
        
        return MusicScore(
            title: title,
            keySignature: keySignature,
            timeSignature: timeSignature,
            tempo: tempo,
            measures: measures,
            instruments: instruments
        )
    }
    
    private static func generateRandomNotesForMeasure(
        timeSignature: TimeSignature,
        keySignature: KeySignature,
        measureNumber: Int
    ) -> [Measure.Note] {
        var notes: [Measure.Note] = []
        var remainingBeats = Double(timeSignature.beats)
        
        while remainingBeats > 0 {
            let availableDurations = Measure.Note.Duration.allCases.filter { $0.value <= remainingBeats }
            guard let randomDuration = availableDurations.randomElement() else { break }
            
            let isRest = Bool.random()
            let note: Measure.Note
            
            if isRest {
                note = Measure.Note(
                    pitch: Instrument.Note(pitch: .c, octave: 4), // Placeholder for rest
                    duration: randomDuration,
                    isRest: true
                )
            } else {
                let randomPitch = generateRandomPitchInKey(keySignature: keySignature)
                note = Measure.Note(
                    pitch: randomPitch,
                    duration: randomDuration,
                    isRest: false
                )
            }
            
            notes.append(note)
            remainingBeats -= randomDuration.value
        }
        
        return notes
    }
    
    private static func generateRandomPitchInKey(keySignature: KeySignature) -> Instrument.Note {
        // Simple random pitch generation within a reasonable range
        let pitches = Instrument.Note.Pitch.allCases
        let randomPitch = pitches.randomElement() ?? .c
        let randomOctave = Int.random(in: 3...5)
        
        return Instrument.Note(pitch: randomPitch, octave: randomOctave)
    }
}

// Predefined time signatures
extension MusicScore.TimeSignature {
    static let commonTimeSignatures: [MusicScore.TimeSignature] = [
        MusicScore.TimeSignature(beats: 4, beatType: 4),
        MusicScore.TimeSignature(beats: 3, beatType: 4),
        MusicScore.TimeSignature(beats: 2, beatType: 4),
        MusicScore.TimeSignature(beats: 6, beatType: 8),
        MusicScore.TimeSignature(beats: 3, beatType: 8),
        MusicScore.TimeSignature(beats: 2, beatType: 2)
    ]
} 