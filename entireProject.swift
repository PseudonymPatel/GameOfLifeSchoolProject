//Array2DB struct
enum CellState {
    case dead, alive, makeDead, makeAlive
}

struct Cell {
    var state:CellState
    
    init(state:CellState) {
        self.state = state
    }
}

struct Array2DB:CustomStringConvertible {
    var values: [Cell]
    let rows: Int
    let cols: Int
    
    //creates the 2-dimensional abstraction of our 'values' array
    var description: String {
        let deadCellIcon = "+ "
        let aliveCellIcon = "█ "
        var d = ""
        for r in 0..<rows {
            for c in 0..<cols {
                let currCell = values[getIndex(row: r, col: c)]
                if c == cols - 1 {
                    d += ( currCell.state == CellState.alive ? (aliveCellIcon + "\n") : (deadCellIcon + "\n") )
                } else {
                    d += ( currCell.state == CellState.alive ? aliveCellIcon : deadCellIcon )
                }
            }
        }
        return d
    }
    /*
    var count:Int {
        return values.count
    }*/
    
    //a count of all the cells that are currently alive.
    var numberLivingCells:Int {
        var c = 0
        for i in values {
            if i.state == CellState.alive {
                c += 1
            }
        }
        return c
    }
    
    //creates an empty array of 0's according to the specified number of rows and cols
    init(rows: Int, cols: Int) {
        self.rows = rows
        self.cols = cols
        values = [Cell](repeating: Cell(state:CellState.dead), count: (rows+2)*(cols+2)) //TODO: redo so it works
    }
    
    //allows us to use the syntax [row, col] when interacting with an Array2DB
    subscript(row: Int, col: Int) -> Cell {
        get {
            return values[getIndex(row: row, col: col)]
        }
        set(newValue) {
            values[getIndex(row: row, col: col)] = newValue
        }
    }
    
    //converts the abstract idea of row, col to the corresponding index in 'values'
    func getIndex(row: Int, col: Int) -> Int {
        assert((row >= -1) && (row <= rows), "row \(row) is out of bounds")
        assert((col >= -1) && (col <= cols), "col \(col) is out of bounds")
        return (row + 1)*rows + col + 1
    }
    
}

class Colony:CustomStringConvertible {
    var name:String
    var array:Array2DB
    var exit = false
    var generation:Int = 0
    
    var description:String {
        return "\(name) on generation \(generation)\n\(array)"
    }
    
    init(name:String, size:Int) {
        self.name = name
        self.array = Array2DB(rows:size, cols:size)
    }
    
    //sets a cell to become alive on the next run
    func setCellAlive(_ row:Int,_ col:Int, now:Bool = true) {
        if now {    
            array[row, col].state = CellState.alive
        } else {
            array[row, col].state = CellState.makeAlive
        }
    }
    
    //kill a cell for the next run
    func setCellDead(_ row:Int,_ col:Int) {
        array[row, col].state = CellState.dead
    }
    
    //reset
    func resetColony() {
        for r in 0..<array.rows {
            for c in 0..<array.cols {
                array[r, c].state = CellState.dead
            }
        }
    }
    
    //finds if the cell named is alive.
    func isCellAlive(_ row:Int,_ col:Int) -> Bool {
        return (array[row, col].state == CellState.alive || array[row, col].state == CellState.makeDead)
    }
    
    func numSurroundingCellsAlive(_ row:Int,_ col:Int) -> Int {
        var c:Int = 0
        let cellsToCheck = [(row-1,col-1), (row-1, col), (row-1, col+1), (row, col-1), (row, col+1), (row+1,col-1), (row+1, col), (row+1, col+1)]
        for check in cellsToCheck {
            if array[check.0, check.1].state == CellState.alive || array[check.0, check.1].state == CellState.makeDead {
                c += 1
            }
        }
        
        return c
    }
    
    func evolve(forTurns t:Int = -2) { // -2 means forever
        exit = false
        var i:Int = t
        while (t == -2 && !exit) || (i >= 0 && i <= t && !exit) {
            print(self) //shows current state of the generation
            if array.numberLivingCells == 0 {
                print("oOF wE dED")
                exit = true
            }
            //finding what to do -- marks the next gen
            for r in 0..<array.rows {
                for c in 0..<array.cols {
                    let surrounding = numSurroundingCellsAlive(r, c)
                    //if cell is currently alive
                    if array[r,c].state == CellState.alive {
                        switch surrounding {
                        case 0...1: //dies (0...1)
                            array[r,c].state = CellState.makeDead
                        case 2...3: //nothing (2...3)
                            array[r,c].state = CellState.alive //redundant but for readability -- remove for unmaintainablility compliance
                        case 4...8: //dies (4...8)
                            array[r,c].state = CellState.makeDead
                        default:
                            print("https://youtu.be/LDU_Txk06tM")
                        }
                    } else { //cell is currently dead.
                        if surrounding == 3 { //surrounding == 3
                            array[r, c].state = CellState.makeAlive
                        }
                    }
                }
            }
			
            //making the marked cells into what they actually are
            for r in 0..<array.rows {
                for c in 0..<array.cols {
                    let cell = array[r, c]
                    if cell.state == CellState.makeAlive {
                        array[r, c].state = CellState.alive
                    } else if cell.state == CellState.makeDead {
                        array[r, c].state = CellState.dead
                    }
                }
            }
            
            //iterate to the next generation
            i -= 1
            generation = t-i
        }
    }
}

var a = Colony(name:"test colony", size:20)
a.setCellAlive(4,7, now:true)
a.setCellAlive(5,8, now:true)
a.setCellAlive(6,8, now:true)
a.setCellAlive(6,7, now:true)
a.setCellAlive(6,6, now:true)
a.evolve(forTurns:100)

/*
 
 + + + + + +  row
 + 0 + + + +
 + + + + + +
 + + + + + +
 + + + + + +
 + + + + + +
 
 c
 o
 l
 
 */
