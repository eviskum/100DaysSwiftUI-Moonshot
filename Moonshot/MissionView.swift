//
//  MissionView.swift
//  Moonshot
//
//  Created by Esben Viskum on 22/04/2021.
//

import SwiftUI

struct MissionView: View {
    struct CrewMember {
        let role: String
        let astronaut: Astronaut
    }
    
    let mission: Mission
    let astronauts: [CrewMember]
    let missions: [Mission]
    
    var body: some View {
        GeometryReader { geo in
            ScrollView(.vertical) {
                VStack {
                    GeometryReader { imageGeo in
                        Image(decorative: self.mission.image)
                            .resizable()
                            .scaledToFit()
//                            .frame(maxWidth: geo.size.width * 0.7)
                            .frame(maxWidth: geo.size.width * 0.7 * CGFloat((Double.maximum(Double(imageGeo.frame(in: .global).minY / 80), 0.7))))
                            .padding(.top)
                            .accessibility(hidden: true)
                            .position(x: imageGeo.frame(in: .local).midX, y: imageGeo.frame(in: .local).midY)
//                            .position(x: imageGeo.size.width / 2, y: imageGeo.size.width / 2)
//                        print("\(imageGeo.frame(in: .global).minY)")
//                        }
                    }
                    .frame(height: geo.size.width * 0.7)
//                    .layoutPriority(1)

                    Text(self.mission.formattedLaunchDate)
                        .padding()
                        .accessibility(label: Text("Launch data: \(self.mission.formattedLaunchDate)"))
                    
                    Text(self.mission.description)
                        .padding()
                        .layoutPriority(1)
                    
                    ForEach(self.astronauts, id: \.role) { crewMember in
                        NavigationLink(
                            destination: AstronautView(astronaut: crewMember.astronaut, missions: missions)) {
                            HStack {
                                Image(crewMember.astronaut.id)
                                    .resizable()
                                    .frame(width: 83, height: 60)
                                    .clipShape(Capsule())
                                    .overlay(Capsule().stroke(Color.primary, lineWidth: 1))
                                
                                VStack(alignment: .leading) {
                                    Text(crewMember.astronaut.name)
                                        .font(.headline)
                                    Text(crewMember.role)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    Spacer(minLength: 25)
                }
            }
        }
        .navigationBarTitle(Text(mission.displayName), displayMode: .inline)
    }
    
    init(mission: Mission, astronauts: [Astronaut], missions: [Mission]) {
        self.mission = mission
        self.missions = missions

        var matches = [CrewMember]()
        
        for member in mission.crew {
            if let match = astronauts.first(where: { $0.id == member.name }) {
                matches.append(CrewMember(role: member.role, astronaut: match))
            } else {
                fatalError("Missing \(member)")
            }
        }
        
        self.astronauts = matches
    }
    
}

struct MissionView_Previews: PreviewProvider {
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")

    static var previews: some View {
        MissionView(mission: missions[0], astronauts: astronauts, missions: missions)
    }
}
