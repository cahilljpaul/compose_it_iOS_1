import Foundation
import MultipeerConnectivity

class CollaborativeSession: NSObject, ObservableObject {
    @Published var connectedPeers: [MCPeerID] = []
    @Published var currentScore: MusicScore?
    @Published var isConductor: Bool = false
    @Published var sessionState: SessionState = .disconnected
    
    private var session: MCSession?
    private var advertiser: MCNearbyServiceAdvertiser?
    private var browser: MCNearbyServiceBrowser?
    private let serviceType = "compose-it-session"
    
    enum SessionState {
        case disconnected
        case hosting
        case joining
        case connected
    }
    
    override init() {
        super.init()
    }
    
    func startHosting() {
        let peerID = MCPeerID(displayName: UIDevice.current.name)
        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        session?.delegate = self
        
        advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: serviceType)
        advertiser?.delegate = self
        advertiser?.startAdvertisingPeer()
        
        isConductor = true
        sessionState = .hosting
    }
    
    func joinSession() {
        let peerID = MCPeerID(displayName: UIDevice.current.name)
        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        session?.delegate = self
        
        browser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType)
        browser?.delegate = self
        browser?.startBrowsingForPeers()
        
        isConductor = false
        sessionState = .joining
    }
    
    func stopSession() {
        advertiser?.stopAdvertisingPeer()
        browser?.stopBrowsingForPeers()
        session?.disconnect()
        
        session = nil
        advertiser = nil
        browser = nil
        
        connectedPeers.removeAll()
        sessionState = .disconnected
    }
    
    func sendScore(_ score: MusicScore) {
        guard let session = session, !session.connectedPeers.isEmpty else { return }
        
        do {
            let data = try JSONEncoder().encode(score)
            try session.send(data, toPeers: session.connectedPeers, with: .reliable)
        } catch {
            print("Failed to send score: \(error)")
        }
    }
    
    func sendConductorCommand(_ command: ConductorCommand) {
        guard let session = session, !session.connectedPeers.isEmpty else { return }
        
        do {
            let data = try JSONEncoder().encode(command)
            try session.send(data, toPeers: session.connectedPeers, with: .reliable)
        } catch {
            print("Failed to send conductor command: \(error)")
        }
    }
}

// MARK: - Conductor Commands
struct ConductorCommand: Codable {
    let type: CommandType
    let timestamp: Date
    
    enum CommandType: String, Codable {
        case start = "start"
        case stop = "stop"
        case pause = "pause"
        case resume = "resume"
        case setTempo = "setTempo"
        case setMeasure = "setMeasure"
    }
    
    let tempo: Int?
    let measureNumber: Int?
}

// MARK: - MCSessionDelegate
extension CollaborativeSession: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        DispatchQueue.main.async {
            switch state {
            case .connected:
                if !self.connectedPeers.contains(peerID) {
                    self.connectedPeers.append(peerID)
                }
                self.sessionState = .connected
            case .notConnected:
                self.connectedPeers.removeAll { $0 == peerID }
                if self.connectedPeers.isEmpty {
                    self.sessionState = self.isConductor ? .hosting : .joining
                }
            case .connecting:
                break
            @unknown default:
                break
            }
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            // Try to decode as MusicScore first
            if let score = try? JSONDecoder().decode(MusicScore.self, from: data) {
                self.currentScore = score
                return
            }
            
            // Try to decode as ConductorCommand
            if let command = try? JSONDecoder().decode(ConductorCommand.self, from: data) {
                self.handleConductorCommand(command)
                return
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
    
    private func handleConductorCommand(_ command: ConductorCommand) {
        // Handle conductor commands here
        switch command.type {
        case .start:
            // Start playback
            break
        case .stop:
            // Stop playback
            break
        case .pause:
            // Pause playback
            break
        case .resume:
            // Resume playback
            break
        case .setTempo:
            if command.tempo != nil {
                // Update tempo
                break
            }
        case .setMeasure:
            if command.measureNumber != nil {
                // Jump to specific measure
                break
            }
        }
    }
}

// MARK: - MCNearbyServiceAdvertiserDelegate
extension CollaborativeSession: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        // Auto-accept invitations for now
        invitationHandler(true, session)
    }
}

// MARK: - MCNearbyServiceBrowserDelegate
extension CollaborativeSession: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        // Auto-invite found peers for now
        browser.invitePeer(peerID, to: session!, withContext: nil, timeout: 30)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        // Handle lost peer
    }
} 