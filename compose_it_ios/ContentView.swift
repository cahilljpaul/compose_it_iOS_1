//
//  ContentView.swift
//  compose_it_ios
//
//  Created by Paul Cahill on 25/06/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ScoreGenerationView()
                .tabItem {
                    Image(systemName: "music.note")
                    Text("Generate")
                }
            
            CollaborativeSessionView()
                .tabItem {
                    Image(systemName: "person.2")
                    Text("Collaborate")
                }
        }
    }
}

struct ScoreGenerationView: View {
    @State private var selectedInstrument: Instrument?
    @State private var selectedKeySignature: KeySignature?
    @State private var selectedTimeSignature: MusicScore.TimeSignature = MusicScore.TimeSignature.commonTimeSignatures[0]
    @State private var currentScore: MusicScore?
    @State private var isGeneratingScore = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 8) {
                    Text("Compose It")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Generate and collaborate on music scores")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top)
                
                // Selection controls
                VStack(spacing: 16) {
                    // Instrument selection
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Select Instrument")
                            .font(.headline)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(Instrument.availableInstruments) { instrument in
                                    InstrumentCard(
                                        instrument: instrument,
                                        isSelected: selectedInstrument?.id == instrument.id
                                    ) {
                                        selectedInstrument = instrument
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Key signature selection
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Select Key")
                            .font(.headline)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(KeySignature.commonKeys) { key in
                                    KeySignatureCard(
                                        keySignature: key,
                                        isSelected: selectedKeySignature?.id == key.id
                                    ) {
                                        selectedKeySignature = key
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Time signature selection
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Select Time Signature")
                            .font(.headline)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(MusicScore.TimeSignature.commonTimeSignatures, id: \.displayName) { timeSig in
                                    TimeSignatureCard(
                                        timeSignature: timeSig,
                                        isSelected: selectedTimeSignature.displayName == timeSig.displayName
                                    ) {
                                        selectedTimeSignature = timeSig
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.horizontal)
                
                // Generate button
                Button(action: generateScore) {
                    HStack {
                        if isGeneratingScore {
                            ProgressView()
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: "music.note")
                        }
                        Text(isGeneratingScore ? "Generating..." : "Generate Score")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        canGenerateScore ? Color.blue : Color.gray
                    )
                    .cornerRadius(12)
                }
                .disabled(!canGenerateScore || isGeneratingScore)
                .padding(.horizontal)
                
                // Score display
                if let score = currentScore {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Generated Score")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        StaffView(score: score, selectedInstrument: selectedInstrument)
                            .frame(maxHeight: 300)
                    }
                }
                
                Spacer()
            }
            .navigationBarHidden(true)
        }
    }
    
    private var canGenerateScore: Bool {
        selectedInstrument != nil && selectedKeySignature != nil
    }
    
    private func generateScore() {
        guard let instrument = selectedInstrument,
              let keySignature = selectedKeySignature else { return }
        
        isGeneratingScore = true
        
        // Simulate generation delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            currentScore = MusicScore.generateRandomScore(
                title: "Random Composition",
                keySignature: keySignature,
                timeSignature: selectedTimeSignature,
                instruments: [instrument]
            )
            isGeneratingScore = false
        }
    }
}

struct InstrumentCard: View {
    let instrument: Instrument
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Image(systemName: instrumentIcon(for: instrument.family))
                    .font(.title2)
                
                Text(instrument.name)
                    .font(.caption)
                    .fontWeight(.medium)
                
                Text(instrument.clef.rawValue)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .frame(width: 80, height: 80)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.blue.opacity(0.2) : Color(.systemGray6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func instrumentIcon(for family: Instrument.InstrumentFamily) -> String {
        switch family {
        case .strings: return "music.note"
        case .woodwinds: return "wind"
        case .brass: return "speaker.wave.3"
        case .percussion: return "drumstick"
        case .keyboard: return "pianokeys"
        }
    }
}

struct KeySignatureCard: View {
    let keySignature: KeySignature
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Text(keySignature.tonic.pitch.rawValue)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(keySignature.mode.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if keySignature.sharps > 0 {
                    Text("\(keySignature.sharps) ♯")
                        .font(.caption2)
                        .foregroundColor(.red)
                } else if keySignature.flats > 0 {
                    Text("\(keySignature.flats) ♭")
                        .font(.caption2)
                        .foregroundColor(.blue)
                } else {
                    Text("Natural")
                        .font(.caption2)
                        .foregroundColor(.green)
                }
            }
            .frame(width: 70, height: 70)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.blue.opacity(0.2) : Color(.systemGray6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct TimeSignatureCard: View {
    let timeSignature: MusicScore.TimeSignature
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 2) {
                Text("\(timeSignature.beats)")
                    .font(.title3)
                    .fontWeight(.bold)
                
                Rectangle()
                    .frame(width: 20, height: 1)
                    .foregroundColor(.primary)
                
                Text("\(timeSignature.beatType)")
                    .font(.title3)
                    .fontWeight(.bold)
            }
            .frame(width: 50, height: 50)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color.blue.opacity(0.2) : Color(.systemGray6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ContentView()
}
