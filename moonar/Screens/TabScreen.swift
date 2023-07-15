//
//  ContentView.swift
//  moonar
//
//  Created by Владислав Калиниченко on 20.05.2022.
//

import SwiftUI

struct TabScreen: View {
	@State var emotionColor: Color = blueColor
	@State var emotionTextColor: Color = Color.white
	@State var selection = 0
	@EnvironmentObject var boolState: BoolStates
	@EnvironmentObject var audioThoughts: AudioThoughtViewModel

    var body: some View {
		TabView(selection: $selection) {
			MoonarScreen(emotionColor: $emotionColor, emotionTextColor: $emotionTextColor)
				.tabItem() {
					if selection == 0 {
						Label("", image: "MoonarTab")
					}
					else {
						Label("", image: "MoonarText")
					}
				}
				.tag(0)
			
			UserScreen(emotionColor: $emotionColor)
				.tabItem() {
					if selection == 1 {
						Label("", image: "YouTab")
					}
					else {
						Label("", image: "YouText")
					}
				}
				.tag(1)
		}
		.onAppear() {
			for _ in audioThoughts.fetchedEntitiesAsStrings {
				boolState.AudioBoolList.append(false)
				boolState.AudioIsPlayingList.append(false)
			}
		}
		.accentColor(emotionColor)
    }
}

struct TabScreen_Previews: PreviewProvider {
    static var previews: some View {
		TabScreen()
    }
}
