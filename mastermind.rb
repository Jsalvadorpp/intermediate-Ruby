class MastermindGame
    GAME_TURNS = 12
    CODE_LENGTH = 4

    def initialize
        @secretCode = Array.new(CODE_LENGTH)
        @decodingBoard = Array.new(GAME_TURNS) {Array.new(CODE_LENGTH,"-")}
        @feedBackBoard = Array.new(GAME_TURNS) {Array.new(CODE_LENGTH,"o")}
    end
  
    def newGame
        displayInstructions()
        displayBoard()
        generateSecreteCode()
        win = false

        GAME_TURNS.times do |turn|
            codeBreakerTurn(turn)
            displayBoard()
            answer = []
            for column in 0...CODE_LENGTH
                answer.push(@feedBackBoard[turn][column])
            end

            if answer.all?("*")
                win = true
                break
            end
        end

        if win
            puts "\nyou've guessed the secret code! , you win!"
            puts "secret code : #{@secretCode}"
        else
            puts "\nyou didn't guess the secret code , you lose!"
            puts "secret code : #{@secretCode}"
        end

    end

    def displayInstructions
        puts "guess the four-digits secret code , each digit is a number between [1-6]"
        puts "you have #{GAME_TURNS} turns to guess the secret code"
        puts "use the feedBack section to know if your is correct, by looking the value of each cell"
        puts "* : one cell has the same number and same position"
        puts "@ : one cell has the same number but not same position"
        puts "o : no matching cell"
        puts "NOTE: the order of each cell of the feedBack section doesnt matter"
        puts ""
    end

    def displayBoard

        puts "|Decoding Board |     |    FeedBack   | "
  
        (GAME_TURNS-1).downto(0) do |row|
            
            for column in 0...CODE_LENGTH
                print "| #{@decodingBoard[row][column]} "
            end
            print "|     "
            for column in 0...CODE_LENGTH
                print "| #{@feedBackBoard[row][column]} "
            end
            print "|"
            puts ""
        end
        
    end

    def generateSecreteCode

       @secretCode.each_with_index do |element,index|
            @secretCode[index] = rand(1..6)
       end
    end

    def codeBreakerTurn(turn)
        
        puts "\nturn: #{turn+1}"
        displayDecodingBoardRow(turn)

        for column in 0...CODE_LENGTH
            puts "choose a digit[1-6] for cell ##{column+1}"
            while true 
                digit = gets.chomp.to_i
                break if digit.between?(1,6) 
                puts "invalid digit, try again"
            end
            @decodingBoard[turn][column] = digit
            displayDecodingBoardRow(turn)
        end

        checkPlayerCode(turn)
        puts ""
    end

    def displayDecodingBoardRow(row)
        for column in 0...CODE_LENGTH
            print "| #{@decodingBoard[row][column]} "
        end
        print "|  \n"
    end

    def checkPlayerCode(row)

        randomCells = (0...CODE_LENGTH).to_a.shuffle!
        secretCodeAux = []
        currentDecodingRow = []
 
        #check for matching number and position
        for column in 0...CODE_LENGTH

            if @secretCode[column] == @decodingBoard[row][column]
                feedBackValue = "*"
                cell = randomCells.pop()
                @feedBackBoard[row][cell] = feedBackValue
            else
                secretCodeAux.push(@secretCode[column])
                currentDecodingRow.push(@decodingBoard[row][column])
            end
        end
    
        #check the others conditions
        for column in 0...currentDecodingRow.length
            if secretCodeAux.include? currentDecodingRow[column]
                feedBackValue = "@"
            else
                feedBackValue = "o"
            end

            cell = randomCells.pop()
            @feedBackBoard[row][cell] = feedBackValue
        end

    end

end

game = MastermindGame.new
game.newGame()