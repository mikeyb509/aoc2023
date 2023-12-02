# https://adventofcode.com/2023/day/2

# log all console output
$transcript = "$psscriptroot\part2Transcript.log"
Start-Transcript $transcript -Force

#$lines = Get-Content $psscriptroot\part1sample.txt
$lines = Get-Content $psscriptroot\part1input.txt

$totalPower = 0

$pos = 1

foreach($line in $lines){
    "Analyzing game $pos..."
    "`tLine is: $line"

    # split the "game # bit from the end of the string"
    $line = ($line -split "Game \d*:\s")[1]

    #break the game up into iterations
    $iterations = $line -split ";\s"

    "`tGame has $($iterations.count) iterations"

    $gameOK = $true

    # track the required minimum values for each cube color
    $minBlue = 0
    $minRed = 0
    $minGreen = 0

    for($i = 0; $i -lt $iterations.count; $i++){
        "`tChecking iteration $($i + 1)..."
        "`t`tIteration is: $($iterations[$i])"

        # break the iteration up into cubes
        $cubes = $iterations[$i] -split ",\s"

        $cubeNbr = 1
        foreach($cube in $cubes){
            # split the cube segment into its color and value
            $cubeColor = ($cube -split "\s")[1]
            $cubeValue = ($cube -split "\s")[0]

            "`t`t`tCube $cubeNbr is '$cubeColor' with value '$cubeValue'"

            # check each cube's value to see if it's larger than the current known minimum
            switch($cubeColor){
                "blue"{
                    if([int]$cubeValue -gt $minBlue){
                        "`t`t`t`tThis cube's value is larger than the game's current minimum ($minBlue)... updating minimum"
                        $minBlue = [int]$cubeValue
                    }
                }

                "red"{
                    if([int]$cubeValue -gt $minRed){
                        "`t`t`t`tThis cube's value is larger than the game's current minimum ($minRed)... updating minimum"
                        $minRed = [int]$cubeValue
                    }
                }

                "green"{
                    if([int]$cubeValue -gt $minGreen){
                        "`t`t`t`tThis cube's value is larger than the game's current minimum ($minGreen)... updating minimum"
                        $minGreen = [int]$cubeValue
                    }
                }
            }

            $cubeNbr++
        }
    }

    # calculate the total power for this game and add it to the running total
    $gamePower = $minRed * $minBlue * $minGreen
    $totalPower += $gamePower
    "`tMinimums for this game: Red = $minRed | Blue = $minBlue | Green = $minGreen"
    "`tTotal power for this game: $gamePower | Running Total Power: $totalPower"

    $pos++
}

"`nTotal power required for all games is: $totalPower"
Stop-Transcript

# correct answer is 77607