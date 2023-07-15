//
//  NextButtonForm.swift
//  moonar
//
//  Created by Владислав Калиниченко on 08.04.2022.
//

import SwiftUI

struct NextButtonForm: View {
	@Binding var color: Color
	@Binding var textColor: Color
	var text: String
	var action: () -> Void
	
    var body: some View {
		VStack {
			Spacer()
			Button(action: action) {
				HStack {
					Spacer()
					Text(text)
						.font(.title)
						.fontWeight(.bold)
						
					Spacer()
				}
				.padding(25)
				.background(color)
			}
			.padding()
			.transition(.move(edge: .bottom))
			.foregroundColor(textColor)
			.buttonStyle(OnTapButtonState(newTextColor: textColor))
			.shadow(color: Color.black, radius: 50, x: 0, y: 0)
			.shadow(color: Color.black, radius: 50, x: 0, y: 0)
			.shadow(color: Color.black, radius: 50, x: 0, y: 0)
			.shadow(color: Color.black, radius: 50, x: 0, y: 150)
			.shadow(color: Color.black, radius: 50, x: 0, y: 150)
			.shadow(color: Color.black, radius: 50, x: 0, y: 150)
		}
		.transition(.move(edge: .bottom).combined(with: .opacity))
		.zIndex(4)
    }
}

struct NextButtonForm_Previews: PreviewProvider {
    static var previews: some View {
		NextButtonForm(
			color: .constant(Color.white),
			textColor: .constant(Color.black),
			text: "Next",
			action: { () -> Void in }
		)
    }
}
