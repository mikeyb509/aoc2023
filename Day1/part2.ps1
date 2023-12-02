#https://adventofcode.com/2023/day/1

# log all console output
$transcript = "$psscriptroot\part2Transcript.log"
Start-Transcript $transcript -Force

#$lines = Get-Content .\part2sample.txt
$lines = Get-Content .\part2input.txt

$sum = 0 #numeric total
$pos = 1 #position in the file for debugging purposes

# hash table of alpha numbers -> numeric values
$lkp = @{"one" = 1; "two" = 2; "three" = 3; "four" = 4; "five" = 5;  "six" = 6;  "seven" = 7; "eight" = 8;  "nine" = 9; }

foreach($line in $lines){
    "Checking Line #$pos..."

    "`tLine Is: $line"

    # get all numeric and alphanumeric values in the current string
    $hits = $line | select-string '(?=([0-9])|(one)|(two)|(three)|(four)|(five)|(six)|(seven)|(eight)|(nine))' -AllMatches | % matches

    #get the first and last value from the results we found above
    $first = ($hits[0].Groups | where-object {$_.Success -eq $true -and $_.Value -ne ''}).Value
    $last = ($hits[-1].Groups | where-object {$_.Success -eq $true -and $_.Value -ne ''}).value
    

    # check to see if the first or last result is alphanumeric and convert it to a numeric equivalent if needed
    if($lkp.Contains($first)){
        "`t`tReplacing first $first with $($lkp[$first])"
        $first = $lkp[$first]
    }
    
    if($lkp.Contains($last)){
        "`t`tReplacing last $last with $($lkp[$last])"
        $last = $lkp[$last]
    }

    $lineTotal = "$first$last"

    $sum += [int]$lineTotal

    "`tLine: $pos = First #: $first | Last #: $last | Full Number: $lineTotal | Running Total: $sum"
    $pos++

    
}

"Grand Total is: $sum"

Stop-Transcript

#sample answer is 281
#real answer is 54649