//
//  AudioThoughtsScreen.swift
//  moonar
//
//  Created by Владислав Калиниченко on 16.06.2022.
//

import SwiftUI

struct FullAudioThought: View {
	var id: Int
	@Binding var duration: Double
	@Binding var currentTime: Double
	@EnvironmentObject var audioList: AudioThoughtViewModel
	@EnvironmentObject var boolState: BoolStates
	@EnvironmentObject var audioController: AudioViewModel
	
	var body: some View {
		ZStack(alignment: .leading) {
			RoundedRectangle(cornerRadius: 10)
				.stroke(lineWidth: 7)
				.foregroundColor(Color.white)
				.frame(height: 100)
				.padding(.horizontal, 10)
				.padding(.vertical, 10)
			HStack {
				VStack(spacing: 0) {
					Spacer()
					Button(action: { () -> Void in
						var tmpBool = boolState.AudioBoolList[id]
						tmpBool.toggle()
						
						for i in 0..<boolState.AudioBoolList.count {
							boolState.AudioBoolList[i] = false
						}
						
						boolState.AudioBoolList[id] = tmpBool
						
						for i in 0..<boolState.AudioIsPlayingList.count {
							if i != id {
								boolState.AudioIsPlayingList[i] = false
							}
						}
						
						if boolState.AudioIsPlayingList[id] == false {
							currentTime = 0
							
							duration = abs(audioController.playbackAudio(name: audioList.fetchedEntitiesAsStrings[id]) - 0.2)
							
							Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { timer in
								withAnimation(.linear(duration: 0.1)) {
									currentTime = audioController.currentTime()
								}
								
								if boolState.AudioIsPlayingList[id] == false || boolState.AudioBoolList[id] == false {
									timer.invalidate()
								}
							})
							
							boolState.AudioIsPlayingList[id] = true
						}
						else {
							if audioController.isPlaying() {
								audioController.pauseAudioPlayback()
							}
							else {
								audioController.resumeAudioPlayback()
								
								Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { timer in
									withAnimation(.linear(duration: 0.1)) {
										currentTime = audioController.currentTime()
									}
									
									if boolState.AudioIsPlayingList[id] == false || boolState.AudioBoolList[id] == false {
										timer.invalidate()
									}
								})
							}
						}
						
						NotificationCenter.default.addObserver(forName: NSNotification.Name("Finish"), object: nil, queue: .main, using: { _ in
							boolState.AudioIsPlayingList[id] = false
							boolState.AudioBoolList[id] = false
							
							currentTime = 0
						})
					}) {
						Image(systemName: boolState.AudioBoolList[id] ? "pause.circle.fill" : "play.circle.fill")
							.padding(.leading, 20)
							.font(.system(size: 50))
							.foregroundColor(Color.white)
					}
					Spacer()
				}
				ZStack(alignment: .leading) {
					GeometryReader { geo in
						Rectangle()
							.foregroundColor(darkGrayColor)
							.padding(.vertical, 35)
							.padding(.trailing, 25)
						if boolState.AudioIsPlayingList.firstIndex(of: true) == id {
							Rectangle()
								.foregroundColor(Color.white)
								.frame(width: abs(geo.size.width - 25) * CGFloat((currentTime / duration)))
								.padding(.vertical, 35)
						}
					}
				}
				.mask {
					RoundedRectangle(cornerRadius: 15)
						.padding(.vertical, 35)
						.padding(.trailing, 25)
				}
			}
		}
	}
}

struct AudioThoughtsScreen: View {
	let name: String
	@Binding var duration: Double
	@Binding var currentTime: Double
	@EnvironmentObject var audioList: AudioThoughtViewModel
	
    var body: some View {
		ZStack {
			Background(color: Color.black)
			
			ScrollView() {
				ForEach((0..<Int(audioList.fetchedEntitiesAsStrings.count)).reversed(), id: \.self) { i in
					if String(audioList.fetchedEntitiesAsStrings[i].split(separator: "-")[1]) != String(audioList.fetchedEntitiesAsStrings[min(i + 1, Int(audioList.fetchedEntitiesAsStrings.count) - 1)].split(separator: "-")[1]) || i == Int(audioList.fetchedEntitiesAsStrings.count) - 1 {
						Text(audioList.fetchedEntitiesAsStrings[i].split(separator: "-")[1].description.replacingOccurrences(of: ":", with: "."))
							.padding()
							.font(.title3.weight(.medium))
							.foregroundColor(Color.white)
					}
					
					FullAudioThought(id: i, duration: $duration, currentTime: $currentTime)
					
					if String(audioList.fetchedEntitiesAsStrings[i].split(separator: "-")[4]) == "0" {
						Color(.clear)
							.frame(height: 20)
					}
				}

				Color(.clear)
					.frame(height: 300)
			}
		}
		.navigationTitle(name)
		.navigationBarTitleDisplayMode(.inline)
    }
}

struct AudioThoughtsScreen_Previews: PreviewProvider {
    static var previews: some View {
		AudioThoughtsScreen(name: "Your Audio Recordings", duration: .constant(1.0), currentTime: .constant(0))
    }
}
