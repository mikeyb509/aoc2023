# https://adventofcode.com/2023/day/1

# log all console output
$transcript = "$psscriptroot\part1Transcript.log"
Start-Transcript $transcript -Force

#$lines = Get-Content .\part1sample.txt
$lines = Get-Content .\part1input.txt

$sum = 0

#loop each line in the file
foreach($line in $lines){

    # find all number in the current line
    $hits = $line | select-string '[0-9]' -AllMatches | % matches

    #get the first and last numbers from the results we found above
    $first = $hits[0].value
    $last = $hits[-1].value

    $lineTotal = $first + $last

    $sum += $lineTotal

    "First #: $first | Last #: $last | Full Number: $lineTotal | Running Total: $sum"
}

"Grand Total is: $sum"

Stop-Transcript

#sample answer is 142
#real answer is 54081