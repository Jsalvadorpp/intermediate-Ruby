require 'io/console'  

class MastermindGame
    GAME_TURNS = 12
    CODE_LENGTH = 4

    def initialize
        @secretCode = Array.new(CODE_LENGTH,"-")
        @decodingBoard = Array.new(GAME_TURNS) {Array.new(CODE_LENGTH,"-")}
        @feedBackBoard = Array.new(GAME_TURNS) {Array.new(CODE_LENGTH,"o")}
        @combinationPool = []
    end
  
    def newGame

        puts "*** MasterMind game ***"
        puts "choose a number"
        puts "1.Play as the codebreaker -> try to guess the secret code"
        puts "2.Play as the codemaker   -> the computer will try to guess your code"
        while true 
            option = gets.chomp.to_i
            break if option.between?(1,2) 
            puts "invalid option, try again"
        end

        codeBreaker() if option == 1
        codeMaker()   if option == 2

    end

    def codeMaker

        generatePool()

        puts "insert your secret code , and the PC will try to guess it"
        for column in 0...CODE_LENGTH
            puts "choose a digit[1-6] for cell ##{column+1}"
            while true 
                digit = gets.chomp.to_i
                break if digit.between?(1,6) 
                puts "invalid digit, try again"
            end
            @secretCode[column] = digit
            puts "your secret code: #{@secretCode}"
        end

        displayBoard()
        win = false

        GAME_TURNS.times do |turn|
            
            PC_turn(turn)
            displayBoard()

            if @feedBackBoard[turn].all?("*")
                win = true
                break
            end
        end

        if win
            puts "\nThe PC guessed your code"
            puts "secret code : #{@secretCode}"
        else
            puts "\nThe PC didn't guess the secret code"
        end

    end

    def PC_turn(turn)

        puts "the computer will make a guess"
        print "press any key.."                                                                                                    
        STDIN.getch    
        puts "\nturn #{turn+1}"

        selectGuessFromPool(turn)
        checkPlayerCode(turn,@secretCode,@decodingBoard[turn])
        reducePool(turn)

    end

    def selectGuessFromPool(row)
        guess = @combinationPool.shuffle.pop()   #random selection
        for column in 0...CODE_LENGTH
            @decodingBoard[row][column] = guess[column]
        end

    end

    def reducePool(row)

        guessFeedBack = [@feedBackBoard[row].count("*"),@feedBackBoard[row].count("@")] 
        possibleSolutions = []  

        @combinationPool.each do |combination|

            checkPlayerCode(row,@decodingBoard[row],combination)
            combinationScore = [@feedBackBoard[row].count("*"),@feedBackBoard[row].count("@")]   

            possibleSolutions.push(combination) if combinationScore == guessFeedBack

        end

        @combinationPool = possibleSolutions.dup()
        checkPlayerCode(row,@secretCode,@decodingBoard[row])

    end

    def generatePool

        for x1 in 1..6
            for x2 in 1..6
                for x3 in 1..6
                    for x4 in 1..6
                        @combinationPool.push([x1,x2,x3,x4])
                    end
                end
            end
        end
    end

    def codeBreaker

        displayInstructions()
        displayBoard()
        generateSecreteCode()
        win = false

        GAME_TURNS.times do |turn|
            codeBreakerTurn(turn)
            displayBoard()

            if @feedBackBoard[turn].all?("*")
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
        puts "NOTE: the order of each cell of the feedBack section doesnt matter\n"
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
            print "|\n"
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

        checkPlayerCode(turn,@secretCode,@decodingBoard[turn])
        puts ""
    end

    def displayDecodingBoardRow(row)
        for column in 0...CODE_LENGTH
            print "| #{@decodingBoard[row][column]} "
        end
        print "|  \n"
    end

    def checkPlayerCode(row,codeToCheck,guess)

        randomCells = (0...CODE_LENGTH).to_a.shuffle!
        secretCodeAux = []
        currentDecodingRow = []
        #check for matching number and position
        for column in 0...CODE_LENGTH

            if codeToCheck[column] == guess[column]
                feedBackValue = "*"
                cell = randomCells.pop()
                @feedBackBoard[row][cell] = feedBackValue
            else
                secretCodeAux.push(codeToCheck[column])
                currentDecodingRow.push(guess[column])
            end
        end
        #check the others conditions
        for column in 0...currentDecodingRow.length
            if secretCodeAux.include? currentDecodingRow[column]
                feedBackValue = "@"
                secretCodeAux.delete_at(secretCodeAux.find_index(currentDecodingRow[column]))
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