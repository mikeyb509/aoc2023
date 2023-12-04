# https://adventofcode.com/2023/day/3

# log all console output
$transcript = "$psscriptroot\part2Transcript.log"
Start-Transcript $transcript -Force

#$lines = Get-Content $psscriptroot\part2sample.txt
$lines = Get-Content $psscriptroot\part2input.txt

$specialCharacters = '[0-9]'

$pos = 0

$ratioSum = 0

foreach($line in $lines){
    
    "Checking line #$($pos + 1): $line"

    # get all asterisks in the current line (variables here could have been better... copied from part 1)
    $lineNums = ($line | select-string '\*' -AllMatches | % Matches).Groups | Where-Object {$_.Success -eq -$true -and $_.Value -ne ''}

    if($lineNums.Count -eq 0){
        "`tLine has no asterisk"
    } else {
        "`tLine has $($lineNums.Count) asterisks"

        foreach ($lineNum in $lineNums){
            $numMatches = 0
            $locations = @()

            "`t`Asterisk '$lineNum' is in position $($lineNum.Index + 1)"
            
            #check position to the left
            if($lineNum.Index -gt 0){
                # character to the left
                "`t`tChecking character at left in position $($lineNum.Index)"
                
                $charPos = $lineNum.Index - 1
                $charToCheck = $line[$charPos]
               
                if($charToCheck -match $specialCharacters){
                    
                    
                    $ratio = (($line | select-string '\d*' -AllMatches | % Matches).Groups | Where-Object {$_.Success -eq -$true -and $_.Value -ne '' -and $charPos -ge $_.Index -and $charPos -le ($_.Index + $_.Length - 1)}).Value
                    "`t`t`tThis asterisk is adjacent to a digit at the left! Adding '$ratio' to Inventory!"
                    $locations += @{"Left" = [int]$ratio}
                    $numMatches++
                } 
            }
            
        
            #character to the right
            if(($lineNum.Index + $lineNum.Length) -lt $line.Length){   
                "`t`tChecking character at right in position $($lineNum.Index + $lineNum.Length)" 
                $charPos = $lineNum.Index + $lineNum.Length
                $charToCheck = $line[$charPos]
            
                if($charToCheck -match $specialCharacters){
                    

                    $ratio = (($line | select-string '\d*' -AllMatches | % Matches).Groups | Where-Object {$_.Success -eq -$true -and $_.Value -ne '' -and $charPos -ge $_.Index -and $charPos -le ($_.Index + $_.Length - 1)}).Value

                    "`t`t`tThis asterisk is adjacent to a digit at the right! Adding '$ratio' to Inventory!"
                    $locations += @{"Right" = [int]$ratio}
                    $numMatches++
                }
            }
            
            #check row above -- use the same general check for column 0, the maximum length of the line, and whether we're on the first or last line already
            if($pos -gt 0){
                if($lineNum.Index -gt 0){
                    if(($lineNum.Index + $lineNUm.Length) -ge $line.Length){
                        $colsToCheck = ($lineNum.Index - 1) .. ($lineNum.Index + ($lineNum.Length - 1))
                    } else {
                        $colsToCheck = ($lineNum.Index - 1) .. ($lineNum.Index + $lineNum.Length)
                    }
                } else {
                    if(($lineNum.Index + $lineNum.Length) -ge $line.Length){
                        $colsToCheck = ($lineNum.Index) .. ($lineNum.Index + ($lineNum.Length - 1))
                    } else {
                        $colsToCheck = ($lineNum.Index) .. ($lineNum.Index + $lineNum.Length)
                    }
                }

                $colsChecked = @()
                "`t`tChecking columns $($colsToCheck -join ', ') on previous line $($pos)"
                foreach($colToCheck in $colsToCheck){

                    # make sure that the column we're checking wasn't already captured by a digit we may have found
                    if(!($colsChecked.Contains(([int]$colToCheck)))){
                        "`t`t`tChecking column $colToCheck..."
                        $charToCheck = $lines[$pos - 1][$colToCheck]

                        if($charToCheck -match $specialCharacters){
                            
                            $ratio = (($lines[$pos - 1] | select-string '\d*' -AllMatches | % Matches).Groups | Where-Object {$_.Success -eq -$true -and $_.Value -ne '' -and $colToCheck -ge $_.Index -and $colToCheck -le ($_.Index + $_.Length)})
                            
                            $numMatches++
                            $locations += @{"Top" = [int]$ratio.Value}
                            "`t`t`t`tThis number is adjacent to a special character in the previous line at position $colToCheck! Adding '$ratio' to inventory!"
                            
                            # this array keeps track of all columns related to the digit we just found.
                            # in order to prevent the number from being erroneously counted multiple times, we'll skip any remaining 
                            # columns for the remaining digits in the number
                            $colsChecked += $ratio.Index .. ($ratio.Index + $ratio.Length - 1)
                            "`t`t`t`tAdding $([int]$ratio.Index .. [int]($ratio.Index + $ratio.Length - 1) -join ', ') to the list of columns already reviewed"
                            
                        }
                    }
                }
            }
            
            #check row below -- use the same general check as above and in part 1
            if(($pos + 1) -lt $lines.Count){
                if($lineNum.Index -gt 0){
                    if(($lineNum.Index + $lineNUm.Length) -ge $line.Length){
                        $colsToCheck = ($lineNum.Index - 1) .. ($lineNum.Index + ($lineNum.Length - 1))
                    } else {
                        $colsToCheck = ($lineNum.Index - 1) .. ($lineNum.Index + $lineNum.Length)
                    }
                } else {
                    if(($lineNum.Index + $lineNum.Length) -ge $line.Length){
                        $colsToCheck = ($lineNum.Index) .. ($lineNum.Index + ($lineNum.Length - 1))
                    } else {
                        $colsToCheck = ($lineNum.Index) .. ($lineNum.Index + $lineNum.Length)
                    }
                }

                $colsChecked = @()
                "`t`tChecking columns $colsToCheck on next line $($pos + 1)"
                foreach($colToCheck in $colsToCheck){
                    if(!($colsChecked.Contains(([int]$colToCheck)))){
                        "`t`t`tChecking column $colToCheck..."
                        $charToCheck = $lines[$pos + 1][$colToCheck]

                        if($charToCheck -match $specialCharacters){
                            
                            $ratio = (($lines[$pos + 1] | select-string '\d*' -AllMatches | % Matches).Groups | Where-Object {$_.Success -eq -$true -and $_.Value -ne '' -and $colToCheck -ge $_.Index -and $colToCheck -le ($_.Index + $_.Length)})
                            
                            $numMatches++
                            $locations += @{"Bottom" = [int]$ratio.Value}
                            "`t`t`t`tThis number is adjacent to a special character in the next line at position $colToCheck! Adding '$ratio' to inventory!"
                            $colsChecked += $ratio.Index .. ($ratio.Index + $ratio.Length - 1)
                            "`t`t`t`tAdding $([int]$ratio.Index .. [int]($ratio.Index + $ratio.Length - 1) -join ', ') to the list of columns already reviewed"
                            
                        }
                    }
                }
            }

            "`t`tThis asterisk has $numMatches adjacent numbers..."

            # if the asterisk has exactly two adjacent numbers, multiply them and add them to the running total
            if($numMatches -eq 2){
                "`t`t`tThere are exactly two matches! Will proceed to get the values of the adjacent numbers"

                $r1 = ($locations.Values)[0]
                $r2 = ($locations.Values)[1]
                $totalRatio = [int]$r1 * [int]$r2
                $ratioSum += $totalRatio

                "`t`t`t`tRatio one is in position $($locations.Keys[0]) with value $r1"
                "`t`t`t`tRatio two is in position $($locations.Keys[1]) with value $r2"
                "`t`t`t`tTotal ratio for this line = $totalRatio  |  Running total = $ratioSum"
            }
        }
    }

    $pos++
}

"`nSum of all adjacent ratios is: $ratioSum"

Stop-Transcript

#76504829 is the correct answer
