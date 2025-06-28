import SwiftUI

// MARK: - Accidental Types
enum AccidentalType {
    case sharp, flat, natural
}

// MARK: - Improved Clef Shapes
struct TrebleClefShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width, h = rect.height
        
        // G clef centered on G4 (second line from bottom)
        let centerY = h * 0.6 // G4 position
        let radius = min(w, h) * 0.15
        
        // Main spiral
        path.move(to: CGPoint(x: w * 0.3, y: centerY + radius * 2))
        path.addCurve(
            to: CGPoint(x: w * 0.5, y: centerY),
            control1: CGPoint(x: w * 0.4, y: centerY + radius * 1.5),
            control2: CGPoint(x: w * 0.45, y: centerY + radius * 0.5)
        )
        path.addCurve(
            to: CGPoint(x: w * 0.7, y: centerY - radius),
            control1: CGPoint(x: w * 0.55, y: centerY - radius * 0.5),
            control2: CGPoint(x: w * 0.65, y: centerY - radius * 0.8)
        )
        
        // Cross stroke
        path.move(to: CGPoint(x: w * 0.2, y: centerY - radius * 0.5))
        path.addLine(to: CGPoint(x: w * 0.8, y: centerY - radius * 0.5))
        
        return path
    }
}

struct BassClefShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width, h = rect.height
        
        // F clef centered on F3 (fourth line from bottom)
        let centerY = h * 0.4 // F3 position
        let radius = min(w, h) * 0.12
        
        // Two dots
        path.addEllipse(in: CGRect(x: w * 0.3, y: centerY - radius * 1.5, width: radius * 0.8, height: radius * 0.8))
        path.addEllipse(in: CGRect(x: w * 0.3, y: centerY + radius * 0.5, width: radius * 0.8, height: radius * 0.8))
        
        // Curved line
        path.move(to: CGPoint(x: w * 0.5, y: centerY - radius * 2))
        path.addCurve(
            to: CGPoint(x: w * 0.5, y: centerY + radius * 2),
            control1: CGPoint(x: w * 0.7, y: centerY - radius),
            control2: CGPoint(x: w * 0.7, y: centerY + radius)
        )
        
        return path
    }
}

struct AltoClefShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width, h = rect.height
        
        // C clef centered on C4 (middle line)
        let centerY = h * 0.5
        let radius = min(w, h) * 0.15
        
        // Two curves forming a C
        path.move(to: CGPoint(x: w * 0.3, y: centerY))
        path.addCurve(
            to: CGPoint(x: w * 0.7, y: centerY),
            control1: CGPoint(x: w * 0.5, y: centerY - radius),
            control2: CGPoint(x: w * 0.5, y: centerY - radius)
        )
        
        return path
    }
}

// MARK: - Improved Accidental Shapes
struct SharpShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width, h = rect.height
        
        // Two vertical lines
        path.move(to: CGPoint(x: w * 0.3, y: 0))
        path.addLine(to: CGPoint(x: w * 0.3, y: h))
        path.move(to: CGPoint(x: w * 0.7, y: 0))
        path.addLine(to: CGPoint(x: w * 0.7, y: h))
        
        // Two horizontal lines
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
        
        // Vertical line
        path.move(to: CGPoint(x: w * 0.5, y: 0))
        path.addLine(to: CGPoint(x: w * 0.5, y: h))
        
        // Curved part
        path.move(to: CGPoint(x: w * 0.5, y: h * 0.6))
        path.addQuadCurve(
            to: CGPoint(x: w * 0.8, y: h * 0.8),
            control: CGPoint(x: w * 0.7, y: h * 0.5)
        )
        
        return path
    }
}

struct NaturalShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width, h = rect.height
        
        // Two vertical lines
        path.move(to: CGPoint(x: w * 0.3, y: 0))
        path.addLine(to: CGPoint(x: w * 0.3, y: h))
        path.move(to: CGPoint(x: w * 0.7, y: 0))
        path.addLine(to: CGPoint(x: w * 0.7, y: h))
        
        // Two horizontal lines
        path.move(to: CGPoint(x: w * 0.3, y: h * 0.3))
        path.addLine(to: CGPoint(x: w * 0.7, y: h * 0.3))
        path.move(to: CGPoint(x: w * 0.3, y: h * 0.7))
        path.addLine(to: CGPoint(x: w * 0.7, y: h * 0.7))
        
        return path
    }
}

// MARK: - Rest Shapes
struct RestShape: Shape {
    let duration: MusicScore.Measure.Note.Duration
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width, h = rect.height
        
        switch duration {
        case .whole:
            // Whole rest: rectangle hanging from top line
            path.addRect(CGRect(x: w * 0.3, y: 0, width: w * 0.4, height: h * 0.3))
        case .half:
            // Half rest: rectangle sitting on middle line
            path.addRect(CGRect(x: w * 0.3, y: h * 0.35, width: w * 0.4, height: h * 0.3))
        case .quarter:
            // Quarter rest: squiggly line
            path.move(to: CGPoint(x: w * 0.2, y: h * 0.2))
            path.addCurve(
                to: CGPoint(x: w * 0.8, y: h * 0.8),
                control1: CGPoint(x: w * 0.4, y: h * 0.1),
                control2: CGPoint(x: w * 0.6, y: h * 0.9)
            )
        case .eighth:
            // Eighth rest: squiggly line with flag
            path.move(to: CGPoint(x: w * 0.2, y: h * 0.2))
            path.addCurve(
                to: CGPoint(x: w * 0.8, y: h * 0.8),
                control1: CGPoint(x: w * 0.4, y: h * 0.1),
                control2: CGPoint(x: w * 0.6, y: h * 0.9)
            )
            // Add flag
            path.move(to: CGPoint(x: w * 0.8, y: h * 0.8))
            path.addLine(to: CGPoint(x: w * 0.9, y: h * 0.6))
        case .sixteenth:
            // Sixteenth rest: squiggly line with two flags
            path.move(to: CGPoint(x: w * 0.2, y: h * 0.2))
            path.addCurve(
                to: CGPoint(x: w * 0.8, y: h * 0.8),
                control1: CGPoint(x: w * 0.4, y: h * 0.1),
                control2: CGPoint(x: w * 0.6, y: h * 0.9)
            )
            // Add two flags
            path.move(to: CGPoint(x: w * 0.8, y: h * 0.8))
            path.addLine(to: CGPoint(x: w * 0.9, y: h * 0.6))
            path.move(to: CGPoint(x: w * 0.8, y: h * 0.8))
            path.addLine(to: CGPoint(x: w * 0.9, y: h * 0.4))
        case .thirtySecond:
            // Thirty-second rest: squiggly line with three flags
            path.move(to: CGPoint(x: w * 0.2, y: h * 0.2))
            path.addCurve(
                to: CGPoint(x: w * 0.8, y: h * 0.8),
                control1: CGPoint(x: w * 0.4, y: h * 0.1),
                control2: CGPoint(x: w * 0.6, y: h * 0.9)
            )
            // Add three flags
            path.move(to: CGPoint(x: w * 0.8, y: h * 0.8))
            path.addLine(to: CGPoint(x: w * 0.9, y: h * 0.6))
            path.move(to: CGPoint(x: w * 0.8, y: h * 0.8))
            path.addLine(to: CGPoint(x: w * 0.9, y: h * 0.4))
            path.move(to: CGPoint(x: w * 0.8, y: h * 0.8))
            path.addLine(to: CGPoint(x: w * 0.9, y: h * 0.2))
        }
        
        return path
    }
}

// MARK: - Key Signature View
struct KeySignatureView: View {
    let keySignature: KeySignature
    let clef: Instrument.Clef
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<keySignature.sharps, id: \.self) { i in
                SharpShape()
                    .stroke(Color.primary, lineWidth: 1.5)
                    .frame(width: 8, height: 16)
                    .offset(y: sharpOffset(index: i, clef: clef))
            }
            ForEach(0..<keySignature.flats, id: \.self) { i in
                FlatShape()
                    .stroke(Color.primary, lineWidth: 1.5)
                    .frame(width: 8, height: 16)
                    .offset(y: flatOffset(index: i, clef: clef))
            }
        }
    }
    
    private func sharpOffset(index: Int, clef: Instrument.Clef) -> CGFloat {
        // Sharp order: F C G D A E B
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
        // Flat order: B E A D G C F
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

// MARK: - Time Signature View
struct TimeSignatureView: View {
    let timeSignature: MusicScore.TimeSignature
    
    var body: some View {
        VStack(spacing: 0) {
            Text("\(timeSignature.beats)")
                .font(.system(size: 14, weight: .bold, design: .serif))
                .foregroundColor(.primary)
            Text("\(timeSignature.beatType)")
                .font(.system(size: 14, weight: .bold, design: .serif))
                .foregroundColor(.primary)
        }
        .frame(width: 12)
    }
}

// MARK: - Note Head Shapes
struct NoteHeadShape: Shape {
    let isHollow: Bool
    
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
            path.addQuadCurve(
                to: CGPoint(x: w, y: h * 0.5),
                control: CGPoint(x: w * 0.5, y: h * 1.2)
            )
        } else {
            path.move(to: CGPoint(x: 0, y: 0))
            path.addQuadCurve(
                to: CGPoint(x: w, y: h * 0.5),
                control: CGPoint(x: w * 0.5, y: -h * 0.2)
            )
        }
        
        return path
    }
}

// MARK: - Note View
struct NoteView: View {
    let note: MusicScore.Measure.Note
    let clef: Instrument.Clef
    let staffHeight: CGFloat
    @Environment(\.score) var score: MusicScore?
    
    var body: some View {
        ZStack {
            if note.isRest {
                // Render rest
                RestShape(duration: note.duration)
                    .stroke(Color.primary, lineWidth: 1.5)
                    .frame(width: 16, height: 16)
                    .offset(y: restYOffset())
            } else {
                // Render note
                // Ledger lines (max 2 above/below staff)
                ForEach(limitedLedgerLineYs(), id: \.self) { y in
                    Rectangle()
                        .frame(width: 24, height: 1)
                        .foregroundColor(.primary)
                        .offset(y: y)
                }
                
                HStack(spacing: 0) {
                    // Accidental
                    if let accidental = accidentalType() {
                        accidentalShape(for: accidental)
                            .stroke(Color.primary, lineWidth: 1.5)
                            .frame(width: 8, height: 16)
                            .offset(x: -12, y: 0)
                    }
                    
                    // Note head with stem and flags
                    NoteHeadWithStemAndFlags(
                        note: note,
                        stemDirection: stemDirection,
                        noteYOffset: noteYOffset(),
                        flagCount: flagCount(for: note.duration),
                        staffHeight: staffHeight
                    )
                }
                .offset(y: noteYOffset())
            }
        }
        .frame(height: staffHeight)
        .clipped()
    }
    
    // MARK: - Note Positioning
    private func noteYOffset() -> CGFloat {
        let staffSpacing: CGFloat = 8
        let midi = midiNumber(for: note.pitch)
        
        // Define middle C for each clef
        let middleC: Int
        switch clef {
        case .treble: middleC = 60 // C4
        case .bass: middleC = 48   // C3
        case .alto, .tenor: middleC = 53 // C4
        }
        
        // Calculate offset from middle C
        let offset = CGFloat(middleC - midi) * staffSpacing / 2.0
        return offset
    }
    
    private func midiNumber(for note: Instrument.Note) -> Int {
        let base = ["C": 0, "C#": 1, "D": 2, "D#": 3, "E": 4, "F": 5, "F#": 6, "G": 7, "G#": 8, "A": 9, "A#": 10, "B": 11]
        let pitch = base[note.pitch.rawValue] ?? 0
        return (note.octave + 1) * 12 + pitch
    }
    
    // MARK: - Accidental Logic
    private func accidentalType() -> AccidentalType? {
        guard let score = score else { return nil }
        
        let pitch = note.pitch
        let keySignature = score.keySignature
        
        // Check if note is in key signature
        if isNoteInKeySignature(pitch, keySignature) {
            return nil
        }
        
        // Determine accidental based on note name
        if pitch.pitch.rawValue.contains("#") {
            return .sharp
        } else if pitch.pitch.rawValue.contains("b") {
            return .flat
        } else {
            // For natural notes, check if they need a natural sign
            return .natural
        }
    }
    
    private func isNoteInKeySignature(_ note: Instrument.Note, _ keySignature: KeySignature) -> Bool {
        // Simplified check - in a real app, this would be more sophisticated
        
        // For demo purposes, assume C major (no sharps/flats)
        if keySignature.sharps == 0 && keySignature.flats == 0 {
            return !note.pitch.rawValue.contains("#") && !note.pitch.rawValue.contains("b")
        }
        
        return false
    }
    
    private func accidentalShape(for type: AccidentalType) -> AnyShape {
        switch type {
        case .sharp: return AnyShape(SharpShape())
        case .flat: return AnyShape(FlatShape())
        case .natural: return AnyShape(NaturalShape())
        }
    }
    
    // MARK: - Stem Direction
    private var stemDirection: StemDirection {
        let y = noteYOffset()
        // Stem up if note is below middle line, down if above
        return y > 0 ? .up : .down
    }
    
    enum StemDirection { case up, down }
    
    // MARK: - Flag Count
    private func flagCount(for duration: MusicScore.Measure.Note.Duration) -> Int? {
        switch duration {
        case .eighth: return 1
        case .sixteenth: return 2
        case .thirtySecond: return 3
        default: return nil
        }
    }
    
    // MARK: - Ledger Lines
    private func ledgerLineYs() -> [CGFloat] {
        let staffSpacing: CGFloat = 8
        let midi = midiNumber(for: note.pitch)
        
        // Define staff range for each clef
        let (top, bottom): (Int, Int)
        switch clef {
        case .treble: top = 64; bottom = 77  // E4 to F5
        case .alto, .tenor: top = 55; bottom = 69  // G3 to A4
        case .bass: top = 43; bottom = 57  // G2 to A3
        }
        
        var lines: [CGFloat] = []
        
        // Above staff
        if midi > bottom {
            let steps = (midi - bottom) / 2
            for i in 1...steps {
                let y = CGFloat(i * 2) * staffSpacing / 2.0
                lines.append(y)
            }
        }
        
        // Below staff
        if midi < top {
            let steps = (top - midi) / 2
            for i in 1...steps {
                let y = -CGFloat(i * 2) * staffSpacing / 2.0
                lines.append(y)
            }
        }
        
        return lines
    }
    
    // Limit ledger lines to 2 above/below staff
    private func limitedLedgerLineYs() -> [CGFloat] {
        let ys = ledgerLineYs()
        if ys.count <= 4 { return ys }
        if let minY = ys.min(), let maxY = ys.max() {
            return ys.filter { $0 == minY || $0 == maxY || $0 == 0 }
        }
        return ys
    }
    
    // MARK: - Rest Positioning
    private func restYOffset() -> CGFloat {
        // Position rests in the middle of the staff
        return 0
    }
}

// MARK: - Note Head with Stem and Flags
struct NoteHeadWithStemAndFlags: View {
    let note: MusicScore.Measure.Note
    let stemDirection: NoteView.StemDirection
    let noteYOffset: CGFloat
    let flagCount: Int?
    let staffHeight: CGFloat
    
    var body: some View {
        ZStack(alignment: stemDirection == .up ? .bottomLeading : .topTrailing) {
            // Note head
            NoteHeadShape(isHollow: note.duration == .half || note.duration == .whole)
                .fill(note.duration == .half || note.duration == .whole ? Color.clear : Color.primary)
                .stroke(Color.primary, lineWidth: note.duration == .half || note.duration == .whole ? 1.5 : 0)
                .frame(width: staffHeight * 0.18, height: staffHeight * 0.12)
            
            // Stem
            Rectangle()
                .frame(width: 1.5, height: staffHeight * 0.4)
                .foregroundColor(.primary)
                .offset(x: stemDirection == .up ? staffHeight * 0.15 : 0, y: stemDirection == .up ? -staffHeight * 0.18 : staffHeight * 0.18)
            
            // Flags
            if let flagCount = flagCount, flagCount > 0 {
                ForEach(0..<flagCount, id: \.self) { i in
                    NoteFlagShape(up: stemDirection == .up)
                        .stroke(Color.primary, lineWidth: 1.5)
                        .frame(width: staffHeight * 0.12, height: staffHeight * 0.12)
                        .offset(
                            x: stemDirection == .up ? staffHeight * 0.18 : -staffHeight * 0.03,
                            y: stemDirection == .up ? -staffHeight * 0.32 - CGFloat(i) * staffHeight * 0.08 : staffHeight * 0.32 + CGFloat(i) * staffHeight * 0.08
                        )
                }
            }
        }
    }
}

// MARK: - Measure View
struct MeasureView: View {
    let measure: MusicScore.Measure
    let instrument: Instrument?
    let clef: Instrument.Clef
    let staffHeight: CGFloat
    let measureWidth: CGFloat
    let showClefAndSignature: Bool
    @Environment(\.score) var score: MusicScore?
    
    var body: some View {
        VStack(spacing: 0) {
            // Measure number (centered)
            Text("\(measure.measureNumber)")
                .font(.caption2)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 2)
            ZStack(alignment: .leading) {
                // Staff lines
                VStack(spacing: staffHeight / 8) {
                    ForEach(0..<5) { _ in
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.primary)
                    }
                }
                .frame(height: staffHeight)
                .padding(.vertical, 8)
                // Clef, key, time signature (always at start of system)
                if showClefAndSignature {
                    HStack(spacing: 4) {
                        clefShape()
                            .stroke(Color.primary, lineWidth: 2)
                            .frame(width: 18, height: staffHeight)
                        KeySignatureView(keySignature: score?.keySignature ?? KeySignature.commonKeys[0], clef: clef)
                            .frame(height: staffHeight)
                        TimeSignatureView(timeSignature: score?.timeSignature ?? MusicScore.TimeSignature.commonTimeSignatures[0])
                            .frame(height: staffHeight)
                            .padding(.leading, 4)
                        Spacer()
                    }
                    .frame(height: staffHeight)
                }
                // Bar lines
                HStack {
                    Rectangle()
                        .frame(width: 2, height: staffHeight)
                        .foregroundColor(.primary)
                    Spacer()
                    Rectangle()
                        .frame(width: 2, height: staffHeight)
                        .foregroundColor(.primary)
                }
                // Notes
                NotesRowView(
                    measure: measure,
                    clef: clef,
                    keyCount: (score?.keySignature.sharps ?? 0) + (score?.keySignature.flats ?? 0),
                    staffHeight: staffHeight
                )
                .frame(height: staffHeight)
                .padding(.leading, showClefAndSignature ? 60 : 24)
            }
            .frame(width: measureWidth, height: staffHeight + 12)
            // Measure number below (centered)
            Text("\(measure.measureNumber)")
                .font(.caption2)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity)
                .padding(.top, 2)
        }
        .frame(width: measureWidth, height: staffHeight + 32)
    }
    
    private func clefShape() -> AnyShape {
        switch clef {
        case .treble: return AnyShape(TrebleClefShape())
        case .bass: return AnyShape(BassClefShape())
        case .alto, .tenor: return AnyShape(AltoClefShape())
        }
    }
}

// MARK: - Notes Row View
struct NotesRowView: View {
    let measure: MusicScore.Measure
    let clef: Instrument.Clef
    let keyCount: Int
    let staffHeight: CGFloat
    
    var body: some View {
        HStack(spacing: 28) {
            Spacer().frame(width: measure.measureNumber == 1 ? 40 + CGFloat(keyCount) * 10 : 16)
            
            ForEach(measure.notes) { note in
                NoteView(note: note, clef: clef, staffHeight: staffHeight)
            }
        }
        .frame(height: staffHeight)
        .clipped()
    }
}

// MARK: - System Row View
struct SystemRowView: View {
    let systemMeasures: [MusicScore.Measure]
    let selectedInstrument: Instrument?
    let clef: Instrument.Clef
    let staffHeight: CGFloat
    let measureWidth: CGFloat
    let showClefAndSignature: Bool
    @Environment(\.score) var score: MusicScore?
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            ForEach(systemMeasures.indices, id: \ .self) { idx in
                MeasureView(
                    measure: systemMeasures[idx],
                    instrument: selectedInstrument,
                    clef: clef,
                    staffHeight: staffHeight,
                    measureWidth: measureWidth,
                    showClefAndSignature: showClefAndSignature && idx == 0 // Only first measure in system
                )
            }
        }
        .padding(.horizontal, 12)
    }
}

// MARK: - Main Staff View
struct StaffView: View {
    let score: MusicScore
    let selectedInstrument: Instrument?
    let measuresPerSystem: Int = 4
    let staffHeight: CGFloat = 64
    let measureWidth: CGFloat = 120
    
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
            .padding(.bottom, 8)

            // Multi-measure systems in a horizontal ScrollView if needed
            GeometryReader { geo in
                let totalWidth = CGFloat(score.measures.count) * measureWidth
                ScrollView(.horizontal, showsIndicators: totalWidth > geo.size.width) {
                    VStack(alignment: .leading, spacing: 32) {
                        ForEach(Array(chunked(score.measures, size: measuresPerSystem).enumerated()), id: \.offset) { (systemIndex, systemMeasures) in
                            SystemRowView(
                                systemMeasures: systemMeasures,
                                selectedInstrument: selectedInstrument,
                                clef: selectedInstrument?.clef ?? .treble,
                                staffHeight: staffHeight,
                                measureWidth: measureWidth,
                                showClefAndSignature: true // Always show at start of system
                            )
                            .environment(\.score, score)
                        }
                    }
                    .padding(.vertical, 16)
                }
                .frame(height: staffHeight + 56) // Add padding for measure numbers and vertical space
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

// MARK: - Extensions
extension Array {
    subscript(safe index: Int) -> Element? {
        (startIndex..<endIndex).contains(index) ? self[index] : nil
    }
}

// MARK: - Environment
private struct ScoreKey: EnvironmentKey {
    static let defaultValue: MusicScore? = nil
}

extension EnvironmentValues {
    var score: MusicScore? {
        get { self[ScoreKey.self] }
        set { self[ScoreKey.self] = newValue }
    }
}

// MARK: - Preview
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
