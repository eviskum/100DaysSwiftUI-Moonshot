//
//  ContentView.swift
//  Moonshot
//
//  Created by Esben Viskum on 22/04/2021.
//

import SwiftUI

/*
struct User: Codable {
    struct Address: Codable {
        var street: String
        var city: String
    }
    
    var name: String
    var address: Address
}
*/


struct Astronaut: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
}

struct Mission: Codable, Identifiable {
    struct CrewRole: Codable {
        let name: String
        let role: String
        
        func getRealName(astronauts: [Astronaut]) -> String {
            
            if let match = astronauts.first(where: { $0.id == self.name }) {
                return match.name
            } else {
                fatalError("Missing \(self.name)")
            }

            //            return "test"
        }
    }

    let id: Int
    let launchDate: Date?
    let crew: [CrewRole]
    let description: String
    
    var displayName: String {
        "Apollo \(id)"
    }
    
    var image: String {
        "apollo\(id)"
    }
    
    var formattedLaunchDate: String {
        if let launchDate = launchDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            return formatter.string(from: launchDate)
        } else {
            return "N/A"
        }
    }
}

struct ContentView: View {
    let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    
    @State private var showCrew = false
    
    var body: some View {
/*        NavigationView {
            List(0..<100) { row in
                NavigationLink(
                    destination: Text("Detail \(row)")) {
                        Text("Navigate \(row)")
                    }
            }
            .navigationBarTitle("SwiftUI")
        }
        
        Button("Decode JSON") {
            let input = """
            {
                "name": "Anders And",
                "address": {
                    "street": "123 Andebygade",
                    "city": "Andeby"
                }
            }
            """
            let data = Data(input.utf8)
            print(data)
            print(input.utf8)
            let decoder = JSONDecoder()
            if let user = try? decoder.decode(User.self, from: data) {
                print(user.address.street)
            }
        } */
        
        NavigationView {
            List(missions) { mission in
                NavigationLink(destination: MissionView(mission: mission, astronauts: self.astronauts, missions: self.missions)) {
                    Image(mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                    
                    VStack(alignment: .leading) {
                        Text(mission.displayName)
                            .font(.headline)
//                        Group {
                            if showCrew {
                                ForEach(mission.crew, id: \.name) {crew in
                                    Text(crew.getRealName(astronauts: astronauts))
                                        .font(.system(size: 10))
                                }
                            } else {
                                Text(mission.formattedLaunchDate)
                            }
//                        }
                    }
                }
            }
            .navigationBarTitle("Moonshot")
            .navigationBarItems(trailing:
                                    Button("Date/Crew") {
                                        showCrew.toggle()
                                    })
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
