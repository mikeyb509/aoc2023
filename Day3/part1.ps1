# https://adventofcode.com/2023/day/3

# log all console output
$transcript = "$psscriptroot\part1Transcript.log"
Start-Transcript $transcript -Force

#$lines = Get-Content $psscriptroot\part1sample.txt
$lines = Get-Content $psscriptroot\part1input.txt

$partNumberSum = 0

$specialCharacters = '[0-9]|\.'

$pos = 0

foreach($line in $lines){
    "Checking line #$($pos + 1): $line"

    # get all of the numbers in the current line
    $lineNums = ($line | select-string '\d*' -AllMatches | % Matches).Groups | Where-Object {$_.Success -eq -$true -and $_.Value -ne ''}

    if($lineNums.Count -eq 0){
        "`tLine has no numbers"
    } else {
        "`tLine has $($lineNums.Count) numbers"

        # loop each number in the list we obtained above
        foreach ($lineNum in $lineNums){
            $validNum = $false

            "`t`Number '$lineNum' is $($lineNum.Length) digits extending from position $($lineNum.Index + 1) to $($lineNum.Index + $lineNum.Length)"
            
            #check position to the left
            if($lineNum.Index -gt 0){
                # character to the left
                "`t`t`tChecking character at left in position $($lineNum.Index)"
                $charToCheck = $line[$lineNum.Index - 1]
               
                # check to see if the character is anything other than a dot or digit
                if(!($charToCheck -match $specialCharacters)){
                    $partNumberSum += [int]$lineNum.Value
                    "`t`t`t`tThis number is adjacent to a special character at the left! Adding $([int]$lineNum.Value) to inventory! Working total is: $partNumberSum"
                    $validNum = $true
                } 
            }
            
            # if the left character wasn't a special character, check the one on the right
            if(!($validNum)){
                #character to the right
                if(($lineNum.Index + $lineNum.Length) -lt $line.Length){   
                    "`t`t`tChecking character at right in position $($lineNum.Index + $lineNum.Length)" 
                    $charToCheck = $line[$lineNum.Index + $lineNum.Length]

                    if(!($charToCheck -match $specialCharacters)){
                        $partNumberSum += [int]$lineNum.Value
                        "`t`t`t`tThis number is adjacent to a special character at the right! Adding $([int]$lineNum.Value) to inventory! Working total is: $partNumberSum"
                        $validNum = $true
                    }
                }
            }

            # if the right character wasn't a special character, chek the row above
            if(!($validNum)){
                #check row above, but only if we aren't on the first line
                if($pos -gt 0){
                    # check to see if the position we're on is beyond the first character
                    if($lineNum.Index -gt 0){
                        # it is... check to make sure we don't check beyond the maximum length of the line
                        if(($lineNum.Index + $lineNUm.Length) -ge $line.Length){
                            $colsToCheck = ($lineNum.Index - 1) .. ($lineNum.Index + ($lineNum.Length - 1))
                        } else {
                            $colsToCheck = ($lineNum.Index - 1) .. ($lineNum.Index + $lineNum.Length)
                        }
                    } else {
                        # it isn't (we're on teh first character).. check to make sure we don't check beyond the maximum length of the line
                        if(($lineNum.Index + $lineNum.Length) -ge $line.Length){
                            $colsToCheck = ($lineNum.Index) .. ($lineNum.Index + ($lineNum.Length - 1))
                        } else {
                            $colsToCheck = ($lineNum.Index) .. ($lineNum.Index + $lineNum.Length)
                        }
                    }

                    "`t`t`tChecking columns $colsToCheck on previous line $($pos)"
                    foreach($colToCheck in $colsToCheck){
                        $charToCheck = $lines[$pos - 1][$colToCheck]
                        
                        if(!($charToCheck -match $specialCharacters)){
                            $partNumberSum += [int]$lineNum.Value
                            "`t`t`t`tThis number is adjacent to a special character in the previous line at position $colToCheck! Adding $([int]$lineNum.Value) to inventory! Working total is: $partNumberSum"
                            $validNum = $true
                            break
                        }
                    }
                }
            }

            # the previous row didn't reveal any special characters so check the next row in the same general manner as above
            if(!($validNum)){
                #check row below
                if(($pos + 1) -lt $lines.Count){ # make sure we're not on the last line already
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

                    "`t`t`tChecking columns $colsToCheck on next line $($pos + 1)"
                    foreach($colToCheck in $colsToCheck){
                        $charToCheck = $lines[$pos + 1][$colToCheck]
                        
                        if(!($charToCheck -match $specialCharacters)){
                            $partNumberSum += [int]$lineNum.Value
                            "`t`t`t`tThis number is adjacent to a special character in the next line at position $colToCheck! Adding $([int]$lineNum.Value) to inventory! Working total is: $partNumberSum"
                            $validNum = $true
                        }
                    }
                }
            }
        }
    }

    $pos++
}

"`nSum of part numbers in engine schematic is: $partNumberSum"

Stop-Transcript

#525119 is correct
