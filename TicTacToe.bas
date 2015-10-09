'This is an attempt at a minimax tic tac toe algorithm in Just BASIC
'the search tree will be contained in tree$
'the nodes will be strings delimited by commas, of the form
'   parentIndex,state,move
'states are 9 character strings of Xs, Os, and underscores
'   XXOOOXXOX as an example

dim tree$(1) 'this may eventually be the search tree
global treeSize, maxTreeSize, gameState$, currentPlayer$, AIPlayer$
treeSize = 0
maxTreeSize = 1

call playGame
print "Game over"
stop

sub playGame
    board$ = "_________"
    currentPlayer$ = "X"
    AIPlayer$ = "O"
    while winner$(board$) = ""
        board$ = updateBoard$(board$, takeTurn(board$))
        call printBoard board$ 
        call switchPlayer
        print "-----------------"
    wend
    print "winner: " + winner$(board$)
end sub

function updateBoard$(board$, move)
    updateBoard$ = left$(board$, move - 1) + currentPlayer$ + mid$(board$, move + 1)
end function

'returns the number of the space moved to
function takeTurn(board$)
    if currentPlayer$ = AIPlayer$ then
        takeTurn = AIMove(board$, AIPlayer$)
    else
        takeTurn = playerMove(board$)
    end if
end function

sub switchPlayer
    if currentPlayer$ = "X" then
        currentPlayer$ = "O"
    else
        currentPlayer$ = "X"
    end if
end sub

function AIMove(board$, AIPlayer$)
    do
        AIMove = int(rnd(1)*9) + 1
    loop while not(mid$(board$, AIMove, 1) = "_")
end function

function playerMove(board$)
    do
        input "Your move: "; playerMove
    loop while not(mid$(board$, playerMove, 1) = "_")
end function

sub printBoard state$
    for i = 0 to 2
        print mid$(state$, 3*i+1, 3)
    next i
end sub

'returns "X", "O", "tie", or ""
'"" means game not over
function winner$(state$)
    winner$ = "tie"
    if instr(state$, "_") then winner$ = ""
    if hasWon(state$, "X") then
        winner$ = "X"
        exit function
    end if
    if hasWon(state$, "O") then winner$ = "O"
end function

function hasWon(state$, player$)
    hasWon = isWinState(state$, player$, 1, 2, 3) or isWinState(state$, player$, 4, 5, 6) or isWinState(state$, player$, 7, 8, 9) or isWinState(state$, player$, 1, 4, 7) or isWinState(state$, player$, 2, 5, 8) or isWinState(state$, player$, 3, 6, 9) or isWinState(state$, player$, 1, 5, 9)  or isWinState(state$, player$, 3, 5, 7)
end function

'returns true if c1, c2, and c3 all contain player$
function isWinState(state$, player$, c1, c2, c3)
    isWinState = (mid$(state$, c1, 1) = player$ and mid$(state$, c2, 1) = player$ and mid$(state$, c3, 1) = player$)
end function

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



