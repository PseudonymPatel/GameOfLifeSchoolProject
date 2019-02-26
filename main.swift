var exit = false
var col = Colony(name:"temp", size:10)
var colonys:[String:Colony] = ["temp":col]
var current = "temp"
while !exit {
	print("\nCommand? ", terminator:"")
	var input = splitStringIntoParts(readLine() ?? "")
	if input.count > 1 && (input[0] == "" || input[0] == " ") {
		input.remove(at: 0)
	}
	switch input[0] {
		case "create":
			var colony = colonys[current]!
			print("Create new colony? Y/n")
			let i = readLine() ?? "n"
			if (i.uppercased() == "Y" || i.uppercased() == "YES") {
				print("How big to make colony? ", terminator:"")
				let inputnum = Int(readLine() ?? "20") ?? 20
				print("name the colony", terminator:"")
				guard let inputname:String = readLine(), inputname != "" else {
					print("colony not created: no name")
					break
				}
				if colonys.count > 1 {
					colonys[inputname] = Colony(name:inputname, size:inputnum)
				} else {
					colonys[inputname] = Colony(name:inputname, size:inputnum)
					colonys["temp"] = nil
					current = inputname
				}
				print("colony size \(inputnum) created, name: \(inputname)")
			} else {
				print("did not create colony")
			}
		case "run":
			let colony = colonys[current]!
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
			let colony = colonys[current]!
			if input.count >= 3 && Int(input[1]) != nil && Int(input[2]) != nil {
				colony.setCellAlive(Int(input[1])!, Int(input[2])!, now:true)
			} else {
				//let simon = "" 
				//while simon != "" {
					print("Enter point to add:", terminator: "")
					let l = splitStringIntoParts(readLine()!)
					if let hedi = Int(l[0]), let sunni = Int(l[1]) {
						colony.setCellAlive(hedi, sunni, now:true)
					}
				//}
			}
			print("current colony state:\n \(colony)")
		case "display", "ls":
			for (_, colony) in colonys {
				print(colony)
			}
		case "current", "cd":
			if input.count < 2 {
                    print("use for command: `[cd/command] directory`")
                }
                
                let oldCurry = current
                current = input[1]
                if colonys[current] != nil {
                    print("Current is \(current)")
                } else {
                    print("There is no data set with this name. Type better.")
                    current = oldCurry
                }

		case "help":
			print("dispay - shows thing\nadd row col - adds at row col, if no param starts in interactive mode\nrun generations - runs x generations, if no param, starts in interactive\ncreate - prompts colony creation/overwrites current colony")
		default:
			print("https://youtu.be/LDU_Txk06tM")
			print("mr. p has big g")
			print("I know you are reading this hedi and i don't care im being cringy now shut the [REDACTED] up")
	}
}
