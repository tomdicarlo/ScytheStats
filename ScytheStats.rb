class String
  def numeric?
    !self.match(/[^0-9]/)
  end
end

class ScytheFaction
  def initialize
  end
  def initialize(name, mat, coins, stars)
    @name = name
    @mat = mat
    @coins = coins
    @stars = stars
  end
  def get_name
    @name
  end
  def get_mat
    @mat
  end
  def get_coins
    @coins
  end
  def get_stars
    @stars
  end
end

class ScytheGame
  def initialize
  end
  def initialize(factions)
    @factions = factions
  end
  def get_factions
    @factions
  end
  def get_size
    @factions.length
  end
end

def addGame()  
  puts "Please input the results of this game in order of placement, in the form faction letter/player mat number/ num coins / num stars"
  puts "Ex: C/2/95/6 A/5/88/3 R/3/70/5 S/3A/53/5"
  input = gets
  toFile = input.clone
  factions = ["A", "C", "R", "N", "T", "S", "P", "V", "F"]
  mats = ["1", "2", "2A", "3", "3A", "4", "5"]
  input.split.each do |faction|
    values = faction.split("/")
    if(!factions.include?(values[0]))
      puts "Invalid faction input, must be the following:" + factions.inspect
      return
    end
    if(!mats.include?(values[1]))
      puts "Invalid player mat input, must be the following:" + mats.inspect
      puts values[1]
      return
    end
    if(!values[2].numeric? || values[2].to_i < -18)
      puts "Invalid coin value, lowest possible value is -18"
      return
    end
    if(!values[3].numeric? || (values[3].to_i < 0 || values[3].to_i > 6))
      puts "Invalid number of stars, must be between 0 and 6"
      return
    end
  end
  games = File.new("scythe_scores.txt", "a")
  games.puts(toFile)
  games.close
end

def getStats()
  puts "Setting up stat calculations, this may take a moment"
  input = File.new("scythe_scores.txt", "r")
  num_games = 0
  games = []
  input.each_line.each do |game|
    num_factions = 0
    factions = []
    game.split.each do |faction|
      info = faction.split("/")
      factions[num_factions] = ScytheFaction.new(info[0],info[1],info[2],info[3])
      num_factions+=1
    end
    games[num_games] = ScytheGame.new(factions.clone)
    num_games+=1 
  end  
  puts "Setup complete"
  factions = ["A", "C", "R", "N", "T", "S", "P", "V", "F"]
  mats = ["1", "2", "2A", "3", "3A", "4", "5"]
  while(true)
    puts "What statistics would you like to see? Enter 'Help' to see all options or enter 'Quit' to return to main menu"
    input = gets.chomp
    if(input == "Help")
      puts "Here are all of the options for viewing statistics:\n\nAvgCoins <Name> : Gives Average Number of Coins per game for a faction/player mat\nex: AvgCoins Nords\n\nAvgStars <Name>: Gives the average stars per game for a faction/player mat\nex: AvgStars 2A"
    end
    if(input == "Quit")
      return
    end
    input = input.split
    if(input[0] == "AvgCoins")
      numCoins = 0
      numCoinGames = 0
      if(factions.include?(input[1].chr))
        games.each do |game|
          game.get_factions.each do |faction|
            if(faction.get_name == input[1].chr)
              numCoins += faction.get_coins.to_i
              numCoinGames +=1
            end
          end
        end
        if(numCoinGames==0)
          puts input[1] + " has no recorded games"
        else
          aveCoins = numCoins.to_f/numCoinGames
          puts "The average number of coins per game for " + input[1] + " is " + aveCoins.to_s
        end
      end
      if(mats.include?(input[1]))
        games.each do |game|
          game.get_factions.each do |faction|
            if(faction.get_mat == input[1])
              numCoins += faction.get_coins.to_i
              numCoinGames +=1
            end
          end
        end
        if(numCoinGames==0)
          puts input[1] + " has no recorded games"
        else
          aveCoins = numCoins.to_f/numCoinGames
          puts "The average number of coins per game for " + input[1] + " is " + aveCoins.to_s
        end
      end
    end
    if(input[0] == "AvgStars")
      numStars = 0
      numStarGames = 0
      if(factions.include?(input[1].chr))
        games.each do |game|
          game.get_factions.each do |faction|
            if(faction.get_name == input[1].chr)
              numStars += faction.get_stars.to_i
              numStarGames +=1
            end
          end
        end
        if(numStarGames==0)
          puts input[1] + " has no recorded games"
        else
          aveStars = numStars.to_f/numStarGames
          puts "The average number of stars per game for " + input[1] + " is " + aveStars.to_s
        end
      end
      if(mats.include?(input[1]))
        games.each do |game|
          game.get_factions.each do |faction|
            if(faction.get_mat == input[1])
              numStars += faction.get_stars.to_i
              numStarGames +=1
            end
          end
        end
        if(numStarGames==0)
          puts input[1] + " has no recorded games"
        else
          aveStars = numStars.to_f/numStarGames
          puts "The average number of stars per game for " + input[1] + " is " + aveStars.to_s
        end
      end
    end
    if(input[0] == "Winrate")
      numWins = 0
      numPlayedGames = 0
      if(factions.include?(input[1].chr))
        games.each do |game|
          first = true
          game.get_factions.each do |faction|
            if(faction.get_name == input[1].chr)
              if(first)
                numWins+=1
              end
              numPlayedGames +=1
            end
            first = false
          end
        end
        if(numPlayedGames==0)
          puts input[1] + " has no recorded games"
        else
          winrate = numWins.to_f/numPlayedGames
          puts "The winrate for " + input[1] + " is " + winrate.to_s
        end
      end
      if(mats.include?(input[1]))
        games.each do |game|
          first = true
          game.get_factions.each do |faction|
            if(faction.get_mat == input[1])
              if(first)
                numWins+=1
              end
              numPlayedGames +=1
            end
          end
        end
        if(numPlayedGames==0)
          puts input[1] + " has no recorded games"
        else
          winrate = numWins.to_f/numPlayedGames
          puts "The winrate for " + input[1] + " is " + winrate.to_s
        end
      end    
    end
  end
end

puts "Welcome to Scythe Stats!"
while(true)
  puts "Please type 'A' to add a new game, 'S' to view stats based on previously recorded games, or 'Q' to exit"
  input = gets.chomp
  if(input == "A")
    addGame()
  end
  if(input == "S")
    getStats()
  end
  if(input == "Q")
    return
  end 
end
