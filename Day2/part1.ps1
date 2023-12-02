# https://adventofcode.com/2023/day/2

# log all console output
$transcript = "$psscriptroot\part1Transcript.log"
Start-Transcript $transcript -Force

#$lines = Get-Content $psscriptroot\part1sample.txt
$lines = Get-Content $psscriptroot\part1input.txt

$validGameTotal = 0

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

    for($i = 0; $i -lt $iterations.count; $i++){
        "`tChecking iteration $($i + 1)..."
        "`t`tIteration is: $($iterations[$i])"

        # break the iterations up into cubes
        $cubes = $iterations[$i] -split ",\s"

        $numBlue = 0;
        $numRed = 0;
        $numGreen = 0
        $blueFail = $false
        $redFail = $false
        $greenFail = $false

        $cubeNbr = 1
        foreach($cube in $cubes){
            # split the cube segment into its color and value
            $cubeColor = ($cube -split "\s")[1]
            $cubeValue = ($cube -split "\s")[0]

            "`t`t`tCube $cubeNbr is '$cubeColor' with value '$cubeValue'"

            # make sure the cube's value is within the allowed range
            switch($cubeColor){
                "blue"{
                    $numBlue = [int]$cubeValue
                    if($numBlue -gt 14) { $blueFail = $true }
                }

                "red"{
                    $numRed = [int]$cubeValue
                    if($numRed -gt 12) { $redFail = $true }
                }

                "green"{
                    $numGreen = [int]$cubeValue
                    if($numGreen -gt 13) { $greenFail = $true }
                }
            }

            $cubeNbr++
        }

       
        # check to see if any of the cube values were higher than allowed -- if they were, the entire game fails, so we'll stop checking other iterations
        if($blueFail -or $redFail -or $greenFail){
            $gameOK = $false
            "`t`tIteration Results: Blue = $numBlue (Failed = $blueFail) | Red = $numRed (Failed = $redFail) | Green = $numGreen (Failed = $greenFail)"
            "`t`tIteration FAILED! Game has failed -- skipping remaining iterations..."
            break
        } else {
            "`t`tIteration Results: Blue = $numBlue (Failed = $blueFail) | Red = $numRed (Failed = $redFail) | Green = $numGreen (Failed = $greenFail)"
            "`t`tIteration Passed -- continuing to next iteration..."
            
        }
    }

    # check to see if all iterations above passed
    if($gameOK){
        $validGameTotal += $pos
        "`tGame $pos passed! Adding game number to running total: $validGameTotal"
    } else {
        "`tGame $pos FAILED! Game will not be added to running total. Using previous total: $validGameTotal"
    }

    $pos++
}

"`nTotal Score from all winning games is: $validGameTotal"
Stop-Transcript

# correct answer is 2679