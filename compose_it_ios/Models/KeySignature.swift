import Foundation

struct KeySignature: Identifiable, Codable, Hashable {
    let id = UUID()
    let tonic: Note
    let mode: Mode
    
    enum Mode: String, CaseIterable, Codable {
        case major = "Major"
        case minor = "Minor"
        case dorian = "Dorian"
        case phrygian = "Phrygian"
        case lydian = "Lydian"
        case mixolydian = "Mixolydian"
        case locrian = "Locrian"
    }
    
    struct Note: Codable, Hashable {
        let pitch: Pitch
        let octave: Int
        
        enum Pitch: String, CaseIterable, Codable {
            case c = "C", cSharp = "C#", d = "D", dSharp = "D#", e = "E", f = "F", 
                 fSharp = "F#", g = "G", gSharp = "G#", a = "A", aSharp = "A#", b = "B"
        }
    }
    
    var displayName: String {
        return "\(tonic.pitch.rawValue) \(mode.rawValue)"
    }
    
    var sharps: Int {
        switch (tonic.pitch, mode) {
        case (.c, .major), (.a, .minor): return 0
        case (.g, .major), (.e, .minor): return 1
        case (.d, .major), (.b, .minor): return 2
        case (.a, .major), (.fSharp, .minor): return 3
        case (.e, .major), (.cSharp, .minor): return 4
        case (.b, .major), (.gSharp, .minor): return 5
        case (.fSharp, .major), (.dSharp, .minor): return 6
        case (.cSharp, .major), (.aSharp, .minor): return 7
        default: return 0
        }
    }
    
    var flats: Int {
        switch (tonic.pitch, mode) {
        case (.f, .major), (.d, .minor): return 1
        case (.b, .major), (.g, .minor): return 2
        case (.e, .major), (.c, .minor): return 3
        case (.a, .major), (.f, .minor): return 4
        case (.d, .major), (.b, .minor): return 5
        case (.g, .major), (.e, .minor): return 6
        case (.c, .major), (.a, .minor): return 7
        default: return 0
        }
    }
}

// Predefined key signatures
extension KeySignature {
    static let commonKeys: [KeySignature] = [
        KeySignature(tonic: Note(pitch: .c, octave: 4), mode: .major),
        KeySignature(tonic: Note(pitch: .g, octave: 4), mode: .major),
        KeySignature(tonic: Note(pitch: .d, octave: 4), mode: .major),
        KeySignature(tonic: Note(pitch: .a, octave: 4), mode: .major),
        KeySignature(tonic: Note(pitch: .e, octave: 4), mode: .major),
        KeySignature(tonic: Note(pitch: .b, octave: 4), mode: .major),
        KeySignature(tonic: Note(pitch: .f, octave: 4), mode: .major),
        KeySignature(tonic: Note(pitch: .a, octave: 4), mode: .minor),
        KeySignature(tonic: Note(pitch: .e, octave: 4), mode: .minor),
        KeySignature(tonic: Note(pitch: .b, octave: 4), mode: .minor),
        KeySignature(tonic: Note(pitch: .fSharp, octave: 4), mode: .minor),
        KeySignature(tonic: Note(pitch: .cSharp, octave: 4), mode: .minor),
        KeySignature(tonic: Note(pitch: .gSharp, octave: 4), mode: .minor)
    ]
} 