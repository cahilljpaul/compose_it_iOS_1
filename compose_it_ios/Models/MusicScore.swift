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
        
        // Create a more musical pattern
        let pattern = generateMusicalPattern(timeSignature: timeSignature, measureNumber: measureNumber)
        
        for patternElement in pattern {
            guard patternElement <= remainingBeats else { break }
            
            let isRest = Bool.random() && patternElement <= 1.0 // Only allow rests for shorter notes
            let note: Measure.Note
            
            if isRest {
                note = Measure.Note(
                    pitch: Instrument.Note(pitch: .c, octave: 4), // Placeholder for rest
                    duration: durationFromValue(patternElement),
                    isRest: true
                )
            } else {
                let randomPitch = generateRandomPitchInKey(keySignature: keySignature, measureNumber: measureNumber)
                note = Measure.Note(
                    pitch: randomPitch,
                    duration: durationFromValue(patternElement),
                    isRest: false
                )
            }
            
            notes.append(note)
            remainingBeats -= patternElement
        }
        
        return notes
    }
    
    private static func generateMusicalPattern(timeSignature: TimeSignature, measureNumber: Int) -> [Double] {
        let totalBeats = Double(timeSignature.beats)
        
        // Create different patterns based on measure number for variety
        switch measureNumber % 4 {
        case 0: // End of phrase - often longer notes
            return [totalBeats] // Whole note
        case 1: // Beginning of phrase - often quarter notes
            return Array(repeating: 1.0, count: Int(totalBeats))
        case 2: // Middle of phrase - mix of durations
            if totalBeats >= 4 {
                return [2.0, 1.0, 1.0] // Half, quarter, quarter
            } else {
                return [1.0, 1.0] // Two quarters
            }
        case 3: // Lead into next phrase - often eighth notes
            if totalBeats >= 2 {
                return Array(repeating: 0.5, count: Int(totalBeats * 2))
            } else {
                return [totalBeats]
            }
        default:
            return [totalBeats]
        }
    }
    
    private static func durationFromValue(_ value: Double) -> Measure.Note.Duration {
        switch value {
        case 4.0: return .whole
        case 2.0: return .half
        case 1.0: return .quarter
        case 0.5: return .eighth
        case 0.25: return .sixteenth
        case 0.125: return .thirtySecond
        default: return .quarter
        }
    }
    
    private static func generateRandomPitchInKey(keySignature: KeySignature, measureNumber: Int) -> Instrument.Note {
        // Generate pitches that are more likely to be in the key signature
        let keyPitches = getPitchesInKey(keySignature)
        let randomPitch = keyPitches.randomElement() ?? .c
        
        // Vary octave based on measure number for more interesting melodies
        let baseOctave = 4
        let octaveVariation = (measureNumber % 3) - 1 // -1, 0, or 1
        let randomOctave = baseOctave + octaveVariation
        
        return Instrument.Note(pitch: randomPitch, octave: randomOctave)
    }
    
    private static func getPitchesInKey(_ keySignature: KeySignature) -> [Instrument.Note.Pitch] {
        // Simplified key signature mapping
        switch keySignature.tonic.pitch {
        case .c:
            return [.c, .d, .e, .f, .g, .a, .b]
        case .g:
            return [.g, .a, .b, .c, .d, .e, .fSharp]
        case .d:
            return [.d, .e, .fSharp, .g, .a, .b, .cSharp]
        case .a:
            return [.a, .b, .cSharp, .d, .e, .fSharp, .gSharp]
        case .e:
            return [.e, .fSharp, .gSharp, .a, .b, .cSharp, .dSharp]
        case .b:
            return [.b, .cSharp, .dSharp, .e, .fSharp, .gSharp, .aSharp]
        case .f:
            return [.f, .g, .a, .b, .c, .d, .e]
        default:
            return [.c, .d, .e, .f, .g, .a, .b] // Default to C major
        }
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