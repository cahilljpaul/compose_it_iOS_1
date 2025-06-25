import Foundation

struct Instrument: Identifiable, Codable, Hashable {
    let id = UUID()
    let name: String
    let clef: Clef
    let range: NoteRange
    let family: InstrumentFamily
    
    enum CodingKeys: String, CodingKey {
        case name, clef, range, family
    }
    
    enum Clef: String, CaseIterable, Codable {
        case treble = "Treble"
        case bass = "Bass"
        case alto = "Alto"
        case tenor = "Tenor"
    }
    
    enum InstrumentFamily: String, CaseIterable, Codable {
        case strings = "Strings"
        case woodwinds = "Woodwinds"
        case brass = "Brass"
        case percussion = "Percussion"
        case keyboard = "Keyboard"
    }
    
    struct NoteRange: Codable, Hashable {
        let lowestNote: Note
        let highestNote: Note
    }
    
    struct Note: Codable, Hashable {
        let pitch: Pitch
        let octave: Int
        
        enum Pitch: String, CaseIterable, Codable {
            case c = "C", cSharp = "C#", d = "D", dSharp = "D#", e = "E", f = "F", 
                 fSharp = "F#", g = "G", gSharp = "G#", a = "A", aSharp = "A#", b = "B"
        }
    }
}

// Predefined instruments
extension Instrument {
    static let availableInstruments: [Instrument] = [
        Instrument(name: "Violin", clef: .treble, range: NoteRange(lowestNote: Note(pitch: .g, octave: 3), highestNote: Note(pitch: .a, octave: 7)), family: .strings),
        Instrument(name: "Viola", clef: .alto, range: NoteRange(lowestNote: Note(pitch: .c, octave: 3), highestNote: Note(pitch: .e, octave: 6)), family: .strings),
        Instrument(name: "Cello", clef: .bass, range: NoteRange(lowestNote: Note(pitch: .c, octave: 2), highestNote: Note(pitch: .a, octave: 5)), family: .strings),
        Instrument(name: "Flute", clef: .treble, range: NoteRange(lowestNote: Note(pitch: .c, octave: 4), highestNote: Note(pitch: .c, octave: 7)), family: .woodwinds),
        Instrument(name: "Clarinet", clef: .treble, range: NoteRange(lowestNote: Note(pitch: .e, octave: 3), highestNote: Note(pitch: .c, octave: 6)), family: .woodwinds),
        Instrument(name: "Trumpet", clef: .treble, range: NoteRange(lowestNote: Note(pitch: .f, octave: 3), highestNote: Note(pitch: .d, octave: 6)), family: .brass),
        Instrument(name: "Piano", clef: .treble, range: NoteRange(lowestNote: Note(pitch: .a, octave: 0), highestNote: Note(pitch: .c, octave: 8)), family: .keyboard)
    ]
} 