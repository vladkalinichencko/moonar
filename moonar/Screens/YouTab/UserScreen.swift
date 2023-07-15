//
//  UserScreen.swift
//  moonar
//
//  Created by Владислав Калиниченко on 09.04.2022.
//

import SwiftUI

struct UserScreen: View {
	@Binding var emotionColor: Color
	@State var duration: Double = 1
	@State var currentTime: Double = 0
	
    var body: some View {
		NavigationView {
			ZStack {
				Background(color: Color.black)
				
				ScrollView {
					EmotionWidget(name: "Your emotion statistics", emojiList: stateOptions)
					
					NavigationLink {
						TextThoughtsScreen(name: "Your Text Thoughts")
					} label: {
						TextThoughtWidget(name: "Your Text Thoughts")
					}
					
					NavigationLink {
						AudioThoughtsScreen(name: "Your Audio Recordings", duration: $duration, currentTime: $currentTime)
					} label: {
						AudioThoughtWidget(name: "Your Audio Recordings", duration: $duration, currentTime: $currentTime)
					}
					
//					NavigationLink {
//						AdviceScreen(name: "moonar's pieces of advice")
//					} label: {
//						AdviceWidget(name: "moonar's pieces of advice")
//					}
//
//					NavigationLink {
//						TasksScreen(name: "Tasks for you")
//					} label: {
//						TaskWidget(name: "Tasks for you")
//					}
				}
			}
			.accentColor(emotionColor)
			.navigationTitle("You")
			.navigationBarTitleDisplayMode(.large)
			.toolbar {
				ToolbarItem() {
					NavigationLink {
						SettingsScreen(emotionColor: $emotionColor)
					} 	label: {
						Image(systemName: "gearshape.fill")
							.scaleEffect(1.1)
							.foregroundColor(Color.white)
					}
				}
			}
		}
    }
}

struct UserScreen_Previews: PreviewProvider {
    static var previews: some View {
		UserScreen(emotionColor: .constant(blueColor)).environmentObject(BoolStates())
			.preferredColorScheme(.dark)
    }
}
