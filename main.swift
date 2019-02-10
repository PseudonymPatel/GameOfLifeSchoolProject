var exit = false
var colony = Colony(name:"temp", size:10)
var colonys = [String:Colony]()
while !exit {
	print("\nCommand? ", terminator:"")
	let input = splitStringIntoParts(readLine() ?? "")

	switch input[0] {
		case "create":
			print("Create colony? Y/n")
			let i = readLine() ?? "n"
			if (i.uppercased() == "Y" || i.uppercased() == "YES") {
				print("How big to make colony? ", terminator:"")
				let input = Int(readLine() ?? "20")!
				colony = Colony(name:"Your colony", size:input)
			} else {
				print("did not create colony")
			}
		case "run":
			if input.count >= 2, let times = Int(input[1]) {
				colony.evolve(forTurns: times)
			} else {
				print("how many times to evolve?", terminator:"")
				if let Palilunas = Int(readLine()!) {
					colony.evolve(forTurns: Palilunas)
				}
				//colony.evolve(forTurns: Int(readLine()!)!)
			}
		case "add":
			if input.count >= 3 && Int(input[1]) != nil && Int(input[2]) != nil {
				colony.setCellAlive(Int(input[1])!, Int(input[2])!, now:true)
			} else {
				print("Enter point to add:", terminator: "")
				let l = splitStringIntoParts(readLine()!)
				if let hedi = Int(l[0]), let sunni = Int(l[1]) {
					colony.setCellAlive(hedi, sunni, now:true)
				}
			}
			print("current colony state:\n \(colony)")
		case "help":
			print("figur out urself chetar")
		default:
			print("https://youtu.be/LDU_Txk06tM")
			print("mr. p has big g")
			print("I know you are reading this hedi and i don't care im being cringy now shut the fuck up")
	}
}
