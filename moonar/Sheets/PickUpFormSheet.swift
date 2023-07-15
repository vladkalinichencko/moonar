//
//  PickUpFormSheet.swift
//  moonar
//
//  Created by Владислав Калиниченко on 15.06.2022.
//

import SwiftUI

struct ListItem: View {
	@State var isSelected = false
	@Binding var sheetPickedUpValue: Bool
	@Binding var color: Color
	@Binding var textColor: Color
	var text: String
	
	var body: some View {
		Button(action: {() -> Void in }) {
			ZStack() {
				HStack() {
					Text(text)
						.foregroundColor(isSelected ? textColor : Color.white)
						.font(.title3.weight(.medium))
						.padding(20)
					Spacer()
				}
				.background(
					RoundedRectangle(cornerRadius: 15, style: .continuous)
						.foregroundColor(isSelected ? color : Color.gray)
				)
			}
			.padding(5)
			.onTapGesture {
				isSelected.toggle()
				sheetPickedUpValue.toggle()
			}
			.onAppear() {
				isSelected = sheetPickedUpValue
			}
		}
		.buttonStyle(OnTapButtonState(newTextColor: textColor))
	}
}

struct PickUpFormSheet: View {
	@Environment(\.dismiss) private var dismiss
	let pickUpList: [String]
	@Binding var sheetPickedUpValues: [Bool]
	@Binding var color: Color
	@Binding var textColor: Color
	var action: () -> Void
	
	var body: some View {
		ZStack {
			Background(color: Color.black)
			
			ScrollView(showsIndicators: false) {
				Color(.clear)
					.frame(height: 50)
				
				VStack(alignment: .leading, spacing: 0) {
					ForEach(pickUpList.indices, id: \.self) { index in
						ListItem(sheetPickedUpValue: $sheetPickedUpValues[index], color: $color, textColor: $textColor, text: pickUpList[index])
					}
				}
				.padding(10)
				
				Color(.clear)
					.frame(height: 300)
			}
			
			VStack {
				Spacer()
				InFormButtonForm(color: $color, textColor: $textColor, text: "Submit", action: {
					action()
					dismiss()
				})
					.zIndex(4)
					.shadow(color: Color.black, radius: 50, x: 0, y: 0)
					.shadow(color: Color.black, radius: 50, x: 0, y: 0)
					.shadow(color: Color.black, radius: 50, x: 0, y: 0)
					.shadow(color: Color.black, radius: 50, x: 0, y: 150)
					.shadow(color: Color.black, radius: 50, x: 0, y: 150)
					.shadow(color: Color.black, radius: 50, x: 0, y: 150)
			}
		}
	}
}
