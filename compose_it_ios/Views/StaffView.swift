import SwiftUI

// Accidental type for music notation
enum AccidentalType {
    case sharp, flat, natural
}

// MARK: - Clef Shapes
struct TrebleClefShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        // Simple treble clef approximation (for demo)
        let w = rect.width, h = rect.height
        path.move(to: CGPoint(x: w * 0.5, y: h * 0.1))
        path.addCurve(to: CGPoint(x: w * 0.5, y: h * 0.9),
                      control1: CGPoint(x: w * 0.9, y: h * 0.2),
                      control2: CGPoint(x: w * 0.1, y: h * 0.8))
        path.addArc(center: CGPoint(x: w * 0.5, y: h * 0.7), radius: w * 0.18, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: false)
        return path
    }
}

struct BassClefShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width, h = rect.height
        // Simple bass clef: a dot and a curve
        path.addArc(center: CGPoint(x: w * 0.4, y: h * 0.6), radius: w * 0.18, startAngle: .degrees(0), endAngle: .degrees(270), clockwise: true)
        path.move(to: CGPoint(x: w * 0.7, y: h * 0.5))
        path.addEllipse(in: CGRect(x: w * 0.7, y: h * 0.45, width: w * 0.08, height: w * 0.08))
        path.move(to: CGPoint(x: w * 0.7, y: h * 0.7))
        path.addEllipse(in: CGRect(x: w * 0.7, y: h * 0.65, width: w * 0.08, height: w * 0.08))
        return path
    }
}

struct AltoClefShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width, h = rect.height
        // Simple alto clef: a stylized C
        path.move(to: CGPoint(x: w * 0.2, y: h * 0.5))
        path.addLine(to: CGPoint(x: w * 0.8, y: h * 0.5))
        path.move(to: CGPoint(x: w * 0.5, y: h * 0.2))
        path.addLine(to: CGPoint(x: w * 0.5, y: h * 0.8))
        return path
    }
}

struct SharpShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width, h = rect.height
        // Simple sharp: two vertical and two slanted lines
        path.move(to: CGPoint(x: w * 0.3, y: 0))
        path.addLine(to: CGPoint(x: w * 0.3, y: h))
        path.move(to: CGPoint(x: w * 0.7, y: 0))
        path.addLine(to: CGPoint(x: w * 0.7, y: h))
        path.move(to: CGPoint(x: 0, y: h * 0.35))
        path.addLine(to: CGPoint(x: w, y: h * 0.25))
        path.move(to: CGPoint(x: 0, y: h * 0.65))
        path.addLine(to: CGPoint(x: w, y: h * 0.55))
        return path
    }
}

struct FlatShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width, h = rect.height
        // Simple flat: vertical line and a curve
        path.move(to: CGPoint(x: w * 0.5, y: 0))
        path.addLine(to: CGPoint(x: w * 0.5, y: h))
        path.move(to: CGPoint(x: w * 0.5, y: h * 0.6))
        path.addQuadCurve(to: CGPoint(x: w * 0.8, y: h * 0.8), control: CGPoint(x: w * 0.7, y: h * 0.5))
        return path
    }
}

struct NaturalShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width, h = rect.height
        // Simple natural: two vertical and two horizontal lines
        path.move(to: CGPoint(x: w * 0.3, y: 0))
        path.addLine(to: CGPoint(x: w * 0.3, y: h))
        path.move(to: CGPoint(x: w * 0.7, y: 0))
        path.addLine(to: CGPoint(x: w * 0.7, y: h))
        path.move(to: CGPoint(x: w * 0.3, y: h * 0.5))
        path.addLine(to: CGPoint(x: w * 0.7, y: h * 0.3))
        path.move(to: CGPoint(x: w * 0.3, y: h * 0.7))
        path.addLine(to: CGPoint(x: w * 0.7, y: h * 0.5))
        return path
    }
}

struct KeySignatureView: View {
    let keySignature: KeySignature
    let clef: Instrument.Clef
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<keySignature.sharps, id: \.self) { i in
                SharpShape()
                    .stroke(Color.primary, lineWidth: 2)
                    .frame(width: 10, height: 18)
                    .offset(y: sharpOffset(index: i, clef: clef))
            }
            ForEach(0..<keySignature.flats, id: \.self) { i in
                FlatShape()
                    .stroke(Color.primary, lineWidth: 2)
                    .frame(width: 10, height: 18)
                    .offset(y: flatOffset(index: i, clef: clef))
            }
        }
    }
    // Staff positions for sharps/flats (G major order)
    private func sharpOffset(index: Int, clef: Instrument.Clef) -> CGFloat {
        // Treble: F C G D A E B (top to bottom)
        let trebleOffsets: [CGFloat] = [-16, -8, -20, -12, -24, -16, -28]
        let bassOffsets: [CGFloat] = [-4, 4, -8, 0, -12, -4, -16]
        let altoOffsets: [CGFloat] = [-10, -2, -14, -6, -18, -10, -22]
        switch clef {
        case .treble: return trebleOffsets[safe: index] ?? 0
        case .bass: return bassOffsets[safe: index] ?? 0
        case .alto, .tenor: return altoOffsets[safe: index] ?? 0
        }
    }
    private func flatOffset(index: Int, clef: Instrument.Clef) -> CGFloat {
        // Treble: B E A D G C F (top to bottom)
        let trebleOffsets: [CGFloat] = [-8, 0, -12, -4, -16, -8, -20]
        let bassOffsets: [CGFloat] = [4, 12, 0, 8, -4, 4, -8]
        let altoOffsets: [CGFloat] = [-2, 6, -6, 2, -10, -2, -14]
        switch clef {
        case .treble: return trebleOffsets[safe: index] ?? 0
        case .bass: return bassOffsets[safe: index] ?? 0
        case .alto, .tenor: return altoOffsets[safe: index] ?? 0
        }
    }
}

struct TimeSignatureView: View {
    let timeSignature: MusicScore.TimeSignature
    var body: some View {
        VStack(spacing: 0) {
            Text("\(timeSignature.beats)")
                .font(.system(size: 16, weight: .bold, design: .serif))
                .foregroundColor(.primary)
            Text("\(timeSignature.beatType)")
                .font(.system(size: 16, weight: .bold, design: .serif))
                .foregroundColor(.primary)
        }
        .frame(width: 16)
    }
}

// Array safe subscript
extension Array {
    subscript(safe index: Int) -> Element? {
        (startIndex..<endIndex).contains(index) ? self[index] : nil
    }
}

struct MeasureView: View {
    let measure: MusicScore.Measure
    let instrument: Instrument?
    let clef: Instrument.Clef
    @Environment(\.score) var score: MusicScore?
    
    var body: some View {
        ZStack(alignment: .leading) {
            // Staff lines
            VStack(spacing: 0) {
                ForEach(0..<5) { _ in
                    Rectangle()
                        .frame(width: 80, height: 1)
                        .foregroundColor(.primary)
                }
            }
            // Clef
            VStack {
                clefShape()
                    .stroke(Color.primary, lineWidth: 2)
                    .frame(width: 20, height: 50)
                    .offset(x: 0, y: 0)
                Spacer()
            }
            .frame(width: 80, height: 50)
            // Key signature (only in first measure)
            if let score = score, measure.measureNumber == 1 {
                VStack {
                    KeySignatureView(keySignature: score.keySignature, clef: clef)
                        .frame(height: 50)
                        .offset(x: 20, y: 0)
                    Spacer()
                }
                .frame(width: 80, height: 50)
                // Time signature after key signature
                VStack {
                    TimeSignatureView(timeSignature: score.timeSignature)
                        .frame(height: 50)
                        .offset(x: 38 + CGFloat(max(score.keySignature.sharps, score.keySignature.flats)) * 12, y: 0)
                    Spacer()
                }
                .frame(width: 80, height: 50)
            }
            // Bar lines
            VStack {
                Rectangle()
                    .frame(width: 2, height: 50)
                    .foregroundColor(.primary)
                    .offset(x: 0, y: 0)
                Spacer()
                Rectangle()
                    .frame(width: 2, height: 50)
                    .foregroundColor(.primary)
                    .offset(x: 78, y: 0)
            }
            .frame(width: 80, height: 50)
            // Notes
            NotesRowView(
                measure: measure,
                clef: clef,
                keyCount: (score?.keySignature.sharps ?? 0) + (score?.keySignature.flats ?? 0)
            )
            .frame(width: 80, height: 50)
            .padding(.top, 4)
            // Measure number
            VStack {
                Text("\(measure.measureNumber)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .offset(x: 60, y: -10)
                Spacer()
            }
        }
        .frame(width: 100, height: 60)
    }
    private func clefShape() -> AnyShape {
        switch clef {
        case .treble: return AnyShape(TrebleClefShape())
        case .bass: return AnyShape(BassClefShape())
        case .alto, .tenor: return AnyShape(AltoClefShape())
        }
    }
}

struct SystemRowView: View {
    let systemMeasures: [MusicScore.Measure]
    let selectedInstrument: Instrument?
    let clef: Instrument.Clef
    @Environment(\.score) var score: MusicScore?
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            ForEach(systemMeasures) { measure in
                MeasureView(measure: measure, instrument: selectedInstrument, clef: clef)
            }
        }
        .padding(.horizontal)
    }
}

struct StaffView: View {
    let score: MusicScore
    let selectedInstrument: Instrument?
    let measuresPerSystem: Int = 4
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
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
            // Multi-measure systems
            ForEach(Array(chunked(score.measures, size: measuresPerSystem).enumerated()), id: \.offset) { (systemIndex, systemMeasures) in
                SystemRowView(systemMeasures: systemMeasures, selectedInstrument: selectedInstrument, clef: selectedInstrument?.clef ?? .treble)
                    .environment(\.score, score)
            }
            Spacer()
        }
        .background(Color(.systemBackground))
    }
    // Helper to chunk array into systems
    private func chunked<T>(_ array: [T], size: Int) -> [[T]] {
        stride(from: 0, to: array.count, by: size).map { start in
            Array(array[start..<min(start + size, array.count)])
        }
    }
}

struct NotesRowView: View {
    let measure: MusicScore.Measure
    let clef: Instrument.Clef
    let keyCount: Int
    @Environment(\.score) var score: MusicScore?
    var body: some View {
        HStack(spacing: 8) {
            Spacer().frame(width: measure.measureNumber == 1 ? 60 + CGFloat(keyCount) * 12 : 24)
            ForEach(measure.notes) { note in
                NoteView(note: note, clef: clef)
            }
        }
    }
}

struct NoteHeadWithStemAndFlags: View {
    let note: MusicScore.Measure.Note
    let stemDirection: NoteView.StemDirection
    let noteYOffset: CGFloat
    let flagCount: Int?
    var body: some View {
        ZStack(alignment: stemDirection == .up ? .bottomLeading : .topTrailing) {
            NoteHeadShape()
                .fill(Color.primary)
                .frame(width: 14, height: 10)
                .offset(y: noteYOffset)
            Rectangle()
                .frame(width: 2, height: 20)
                .foregroundColor(.primary)
                .offset(x: stemDirection == .up ? 10 : 0, y: stemDirection == .up ? -10 : 10)
                .rotationEffect(stemDirection == .up ? .degrees(0) : .degrees(180), anchor: .bottom)
            if let flagCount, flagCount > 0 {
                ForEach(0..<flagCount, id: \ .self) { i in
                    NoteFlagShape(up: stemDirection == .up)
                        .stroke(Color.primary, lineWidth: 2)
                        .frame(width: 10, height: 10)
                        .offset(x: stemDirection == .up ? 12 : -2, y: stemDirection == .up ? -16 - CGFloat(i * 6) : 16 + CGFloat(i * 6))
                }
            }
        }
    }
}

struct NoteView: View {
    let note: MusicScore.Measure.Note
    let clef: Instrument.Clef
    @Environment(\.score) var score: MusicScore?
    
    var body: some View {
        VStack(spacing: 2) {
            if note.isRest {
                Rectangle()
                    .frame(width: 8, height: 12)
                    .foregroundColor(.secondary)
            } else {
                HStack(spacing: 2) {
                    accidentalView
                    NoteHeadWithStemAndFlags(
                        note: note,
                        stemDirection: stemDirection,
                        noteYOffset: noteYOffset(),
                        flagCount: flagCount(for: note.duration)
                    )
                }
            }
            Text(note.duration.rawValue)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
    // MARK: - Accidental Rendering
    private var accidentalView: some View {
        if let accidental = accidentalType() {
            return AnyView(
                accidentalShape(for: accidental)
                    .stroke(Color.primary, lineWidth: 2)
                    .frame(width: 10, height: 18)
            )
        } else {
            return AnyView(EmptyView())
        }
    }
    private func accidentalShape(for type: AccidentalType) -> AnyShape {
        switch type {
        case .sharp: return AnyShape(SharpShape())
        case .flat: return AnyShape(FlatShape())
        case .natural: return AnyShape(NaturalShape())
        }
    }
    // MARK: - Note Head, Stem, Flags
    private func noteYOffset() -> CGFloat {
        // Middle C is line 3 for treble, line 1 for bass, line 3 for alto
        let staffSpacing: CGFloat = 8
        let pitch = note.pitch
        let midi = midiNumber(for: pitch)
        let middleC: Int
        switch clef {
        case .treble: middleC = 60
        case .bass: middleC = 48
        case .alto, .tenor: middleC = 53
        }
        let offset = CGFloat(middleC - midi) * staffSpacing / 2.0
        return offset
    }
    private func midiNumber(for note: Instrument.Note) -> Int {
        let base = ["C": 0, "C#": 1, "D": 2, "D#": 3, "E": 4, "F": 5, "F#": 6, "G": 7, "G#": 8, "A": 9, "A#": 10, "B": 11]
        let pitch = base[note.pitch.rawValue] ?? 0
        return (note.octave + 1) * 12 + pitch
    }
    // Determine if the note needs an accidental
    private func accidentalType() -> AccidentalType? {
        guard score != nil else { return nil }
        let pitch = note.pitch
        // For demo: show sharp for C#, flat for Bb, natural for C natural in sharp keys
        if pitch.pitch.rawValue.contains("#") { return .sharp }
        if pitch.pitch.rawValue.contains("b") { return .flat }
        // In a real app, check if the note is not in the key signature
        return nil
    }
    // Stem direction: up if below middle line, down if above
    private var stemDirection: StemDirection {
        let y = noteYOffset()
        return y > 0 ? .up : .down
    }
    enum StemDirection { case up, down }
    // Number of flags for duration
    private func flagCount(for duration: MusicScore.Measure.Note.Duration) -> Int? {
        switch duration {
        case .eighth: return 1
        case .sixteenth: return 2
        case .thirtySecond: return 3
        default: return nil
        }
    }
}

struct NoteHeadShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addEllipse(in: rect)
        return path
    }
}

struct NoteFlagShape: Shape {
    let up: Bool
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width, h = rect.height
        if up {
            path.move(to: CGPoint(x: 0, y: h))
            path.addQuadCurve(to: CGPoint(x: w, y: h * 0.5), control: CGPoint(x: w * 0.5, y: h * 1.2))
        } else {
            path.move(to: CGPoint(x: 0, y: 0))
            path.addQuadCurve(to: CGPoint(x: w, y: h * 0.5), control: CGPoint(x: w * 0.5, y: -h * 0.2))
        }
        return path
    }
}

// Provide the score to NoteView via environment
private struct ScoreKey: EnvironmentKey {
    static let defaultValue: MusicScore? = nil
}
extension EnvironmentValues {
    var score: MusicScore? {
        get { self[ScoreKey.self] }
        set { self[ScoreKey.self] = newValue }
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