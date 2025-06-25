import SwiftUI
import MultipeerConnectivity

struct CollaborativeSessionView: View {
    @StateObject private var session = CollaborativeSession()
    @State private var showingSessionOptions = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Text("Collaborative Session")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(sessionStateDescription)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Connection status
            HStack {
                Circle()
                    .fill(sessionStateColor)
                    .frame(width: 12, height: 12)
                
                Text(sessionStateText)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if session.sessionState != .disconnected {
                    Button("Disconnect") {
                        session.stopSession()
                    }
                    .font(.caption)
                    .foregroundColor(.red)
                }
            }
            .padding(.horizontal)
            
            // Connected peers
            if !session.connectedPeers.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Connected Musicians (\(session.connectedPeers.count))")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(session.connectedPeers, id: \.self) { peer in
                                PeerCard(peer: peer, isConductor: session.isConductor)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            
            // Conductor controls (if conductor)
            if session.isConductor && session.sessionState == .connected {
                ConductorControlsView(session: session)
            }
            
            // Session options
            if session.sessionState == .disconnected {
                VStack(spacing: 16) {
                    Button(action: { session.startHosting() }) {
                        HStack {
                            Image(systemName: "person.2.circle.fill")
                            Text("Host Session")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .cornerRadius(12)
                    }
                    
                    Button(action: { session.joinSession() }) {
                        HStack {
                            Image(systemName: "person.2.circle")
                            Text("Join Session")
                        }
                        .font(.headline)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
            }
            
            // Current score display
            if let score = session.currentScore {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Current Score")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    StaffView(score: score, selectedInstrument: nil)
                        .frame(maxHeight: 200)
                }
            }
            
            Spacer()
        }
        .padding(.top)
    }
    
    private var sessionStateDescription: String {
        switch session.sessionState {
        case .disconnected:
            return "Start or join a collaborative session"
        case .hosting:
            return "Waiting for musicians to join..."
        case .joining:
            return "Looking for available sessions..."
        case .connected:
            return session.isConductor ? "Conducting session" : "Connected to conductor"
        }
    }
    
    private var sessionStateText: String {
        switch session.sessionState {
        case .disconnected:
            return "Disconnected"
        case .hosting:
            return "Hosting"
        case .joining:
            return "Joining"
        case .connected:
            return "Connected"
        }
    }
    
    private var sessionStateColor: Color {
        switch session.sessionState {
        case .disconnected:
            return .gray
        case .hosting, .joining:
            return .orange
        case .connected:
            return .green
        }
    }
}

struct PeerCard: View {
    let peer: MCPeerID
    let isConductor: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: isConductor ? "person.2.circle.fill" : "person.circle.fill")
                .font(.title2)
                .foregroundColor(isConductor ? .blue : .green)
            
            Text(peer.displayName)
                .font(.caption)
                .fontWeight(.medium)
                .lineLimit(1)
            
            Text(isConductor ? "Conductor" : "Musician")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(width: 80, height: 80)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
}

struct ConductorControlsView: View {
    @ObservedObject var session: CollaborativeSession
    @State private var currentTempo: Int = 120
    @State private var currentMeasure: Int = 1
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Conductor Controls")
                .font(.headline)
                .padding(.horizontal)
            
            // Tempo control
            VStack(alignment: .leading, spacing: 8) {
                Text("Tempo: \(currentTempo) BPM")
                    .font(.subheadline)
                
                HStack {
                    Button("-10") { adjustTempo(-10) }
                        .buttonStyle(ControlButtonStyle())
                    
                    Slider(value: Binding(
                        get: { Double(currentTempo) },
                        set: { currentTempo = Int($0) }
                    ), in: 60...200, step: 1)
                    
                    Button("+10") { adjustTempo(10) }
                        .buttonStyle(ControlButtonStyle())
                }
            }
            .padding(.horizontal)
            
            // Measure control
            VStack(alignment: .leading, spacing: 8) {
                Text("Current Measure: \(currentMeasure)")
                    .font(.subheadline)
                
                HStack {
                    Button("Previous") { adjustMeasure(-1) }
                        .buttonStyle(ControlButtonStyle())
                    
                    Spacer()
                    
                    Button("Next") { adjustMeasure(1) }
                        .buttonStyle(ControlButtonStyle())
                }
            }
            .padding(.horizontal)
            
            // Playback controls
            HStack(spacing: 16) {
                Button("Start") {
                    session.sendConductorCommand(ConductorCommand(type: .start, timestamp: Date(), tempo: nil, measureNumber: nil))
                }
                .buttonStyle(PlaybackButtonStyle(color: .green))
                
                Button("Pause") {
                    session.sendConductorCommand(ConductorCommand(type: .pause, timestamp: Date(), tempo: nil, measureNumber: nil))
                }
                .buttonStyle(PlaybackButtonStyle(color: .orange))
                
                Button("Stop") {
                    session.sendConductorCommand(ConductorCommand(type: .stop, timestamp: Date(), tempo: nil, measureNumber: nil))
                }
                .buttonStyle(PlaybackButtonStyle(color: .red))
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    private func adjustTempo(_ change: Int) {
        currentTempo = max(60, min(200, currentTempo + change))
        session.sendConductorCommand(ConductorCommand(type: .setTempo, timestamp: Date(), tempo: currentTempo, measureNumber: nil))
    }
    
    private func adjustMeasure(_ change: Int) {
        currentMeasure = max(1, currentMeasure + change)
        session.sendConductorCommand(ConductorCommand(type: .setMeasure, timestamp: Date(), tempo: nil, measureNumber: currentMeasure))
    }
}

struct ControlButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.caption)
            .foregroundColor(.blue)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.blue.opacity(0.1))
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct PlaybackButtonStyle: ButtonStyle {
    let color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            .background(color)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

#Preview {
    CollaborativeSessionView()
} 