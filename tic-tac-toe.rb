class Board
    attr_accessor :board
    
    def initialize

        @board = {}
        for cell in 1..9
            @board[cell] = " "
        end

        @boardGrid = Array.new(3) { Array.new(3," ") }
        self.showInstructions
        #self.showBoard
    end

    def showInstructions
        puts "\nUse the right number to select a cell"
        puts " 1 | 2 | 3 ",
             "-----------",
             " 4 | 5 | 6 ",
             "-----------",
             " 7 | 8 | 9 "
        puts ""
    end

    def changeCell(cell,value)
        @board[cell] = value
        @boardGrid[cellToRow(cell)][cellToColumn(cell)] = value
        puts ""
        self.showBoard
        puts ""
    end

    def winningCombination(value)
        #check rows
        3.times do |row|
            validCombination = true
            3.times do |column|
                validCombination = false if @boardGrid[row][column] != value
            end
            return true if validCombination
        end

        #check columns
        3.times do |column|
            validCombination = true
            3.times do |row|
                validCombination = false if @boardGrid[row][column] != value
            end
            return true if validCombination
        end

        #check top right diagonal
        validCombination = true
        3.times do |x|
            validCombination = false if @boardGrid[x][x] != value
        end
        return true if validCombination

        #check top left diagonal
        validCombination = true
        column = 3
        3.times do |x|
            validCombination = false if @boardGrid[x][column-1] != value
        end
        return true if validCombination

        return false
    end

    def showBoard
        cell = 1
        3.times do |row|
            3.times do |column|
                print " #{@board[cell]} "
                #print " #{@boardGrid[row][column]} "
                print "|" unless column == 2
                cell += 1
            end
            puts "\n-----------" unless row == 2
        end
    end

    private

    def cellToColumn(cell)
        return (cell-1)%3
    end

    def cellToRow(cell)
        return row = (cell-1)/3
    end
  
end

class Player
    attr_accessor :name
    attr_accessor :mark

    def initialize(name,mark)
        @name = name
        @mark = mark
    end

    def makeMove(board)
        puts "\n#{name}'s turn , choose where to play [1-9]"
        while true
            cell = gets.chomp.to_i
            break cell if cell.between?(1,9) && board.board[cell] == " " 
            puts "invalid cell, try again"
        end
        board.changeCell(cell,mark)
    end
end

def game

    winner = ""
    board = Board.new
    puts "introduce player1's name"
    name = gets.chomp
    player1 = Player.new(name,"x")
    puts "introduce player2's name"
    name = gets.chomp
    player2 = Player.new(name,"o")

    9.times do |turn|

        if turn%2 == 0
            
            player1.makeMove(board)
            if board.winningCombination(player1.mark)
                winner = "#{player1.name}"
                break 
            end

        else

            player2.makeMove(board)
            if board.winningCombination(player2.mark)
                winner = "#{player2.name}"
                break
            end

        end

        winner = "none" if turn == 8 
    end

    puts "\n Winner: #{winner}"
end

game()


