dim tree$(1) 'this may eventually be the search tree
global treeSize, maxTreeSize
treeSize = 0
maxTreeSize = 1

a$ = ""
for i = 0 to 30
    a$ = a$ + " " + str$(i)
next i
for i = 0 to 30
    call addToTree (nthword$(a$, i," "))
    'call addToTree (chr$(34) + nthword$("  this is a   test", i, " ") + chr$(34))
next i
for i = 0 to 30
    print chr$(34) + tree$(i) + chr$(34)
next i

sub addToTree node$ 
    treeSize = treeSize + 1
    if treeSize > maxTreeSize then 'double size of array
        redim temp$(maxTreeSize)
        for i = 0 to maxTreeSize - 1
            temp$(i) = tree$(i)
        next i
        redim tree$(maxTreeSize*2)
        for i = 0 to maxTreeSize
            tree$(i) = temp$(i)
        next i
        maxTreeSize = maxTreeSize * 2
    end if
    tree$(treeSize - 1) = node$
end sub

'returns the nth word in words, where delimiter$ is the character that separates words
'first word is 0th word
'returns "" if words$ has < n+1 words
function nthword$(words$, n, delimiter$)
    'trim front and back
    while right$(words$, 1) = delimiter$
        words$ = left$(words$, len(words$)-1)
    wend
    while left$(words$, 1) = delimiter$
        words$ = mid$(words$, 2)
    wend
    'extract word
    for i = 0 to n
        delimIndex = instr(words$, delimiter$)
        if delimIndex > 0 then
            word$ = left$(words$, instr(words$, delimiter$)-1)
            words$ = mid$(words$, delimIndex)
            while left$(words$, 1) = delimiter$ 'trim of any extra leading delimieters
                words$ = mid$(words$, 2)
            wend
        else    'there is one word left in words
            word$ = words$
            words$ = ""
        end if
    next i
    nthword$ = word$
end function


