//
//  ResourcesSheet.swift
//  moonar
//
//  Created by Владислав Калиниченко on 20.10.2022.
//

import SwiftUI

struct ResourcesSheet: View {
    var body: some View {
		ZStack {
			Background(color: Color.black)
			
			ScrollView(showsIndicators: false) {
				Color(.clear)
					.frame(height: 50)
			
				Text("moonar is built on knowledge of resources for conducting therapies:")
					.foregroundColor(Color.white)
					.font(.title.weight(.heavy))
					.padding(20)
				
				ForEach(resourcesLinks.indices, id: \.self) { index in
					HStack {
						Link(resourcesLinks[index][0], destination: URL(string: resourcesLinks[index][1])!)
							.foregroundColor(blueColor)
							.padding(.leading, 10)
						
						Spacer()
					}
				}
					.padding(10)

				Color(.clear)
					.frame(height: 300)
			}
		}
    }
}

struct ResourcesSheet_Previews: PreviewProvider {
    static var previews: some View {
        ResourcesSheet()
    }
}
