'This is an attempt at a minimax tic tac toe algorithm in Just BASIC
'the search tree will be contained in tree$
'the nodes will be strings delimited by commas, of the form
'   parentIndex,state
'states are 9 character strings of Xs, Os, and underscores
'   XXOOOXXOX as an example
'X
'XO
' OX

global treeSize, maxTreeSize, gameState$, currentPlayer$, AIPlayer$

call playGame
'board$ = "XO_XO____"
'call printBoard board$
'print maxScore(board$, "O")
'board$ = "___XXO_O_"
'call printBoard board$
'print minScore(board$, "O")

print "Game over"
stop

sub playGame
    board$ = "_________"
    call printBoard board$
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
    call resetTree
    do
        AIMove = miniMaxMove(board$, AIPlayer$)
    loop while not(mid$(board$, AIMove, 1) = "_")
end function

sub resetTree
    redim tree$(1) 'this may eventually be the search tree
    treeSize = 0
    maxTreeSize = 1
end sub

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


'returns comma seperated list of board after all possible moves by player
'first word is number of succesors
function successors$(board$, player$)
    successors$ = ""
    count = 0
    for i = 1 to 9
        if mid$(board$, i, 1) = "_" then
            successors$ = successors$ + ","  + left$(board$, i - 1) + player$ + mid$(board$, i + 1)
            count = count + 1
        end if
    next i
    successors$ = str$(count) + successors$
end function

function miniMaxMove(board$, player$)
    print ""
    'call addToTree ("null," + board$)
    'miniMaxMove = findMax(0, player$)
    'print miniMaxMove
    'print tree$(miniMaxMove)
    maxVal = -1000
    successors$ = successors$(board$, player$)
    alpha = -10000
    beta = 10000
    for i = 1 to val(nthword$(successors$, 0, ","))
        print i
        tempBoard$ = nthword$(successors$, i, ",")
        score = minScore(tempBoard$, player$, alpha, beta)
        'print "--"
        'print tempBoard$ + " " + str$(score)
        'print "--"
        if score > maxVal then
            nextBoard$ = tempBoard$
            maxVal = score
        end if
    next i
    'nextBoard$ = findMax$(board$)
        'while not(val(nthword$(nextBoard$, 0, ",")) = 0)
    '    nextBoard$ = tree$(val(nthword$(nextBoard$, 0, ",")))
    '    print nextBoard$
    'wend
    'nextBoard$ = nthword$(nextBoard$, 1, ",")
    'print ""
    for i = 1 to 9
        if mid$(board$, i, 1) = "_" and mid$(nextBoard$, i, 1) = player$ then miniMaxMove = i
    next i
    'print player$
    'print board$
    'print nextBoard$
    'print miniMaxMove
end function

'return value of sucessor node with highest utitlity value
function findMax(board$, player$, alpha, beta)
    'board$ = nthword$(tree$(node), 1, ",")
    successors$ = successors$(board$, player$)
    nsuccessors = val(nthword$(successors$, 0, ","))
    findMax = -1000
    'print ":: " + successors$
    for i = 1 to nsuccessors
        'call addToTree str$(node) + "," + nthword$(successors$, i, ",")
        findMax = max(findMax, minScore(nthword$(successors$, i, ","), player$, alpha, beta))
        if findMax >= beta then exit function 'return findMax
        alpha = max(alpha, findMax)
        'print "  " + str$(score) + " " + nthword$(successors$, i, ",")
        'print "maxscore: " + tree$(treeSize-1) + " " + str$(score)
        'if score > findMax then
        '    'findMax$ = nthword$(successors$, i, ",")
        '    findMax = score
        'end if
    next i
end function

'returns the score of a min node
function minScore(board$, maxPlayer$, alpha, beta)
    'board$ = nthword$(tree$(node), 1, ",")
    if winner$(board$) = maxPlayer$ then
        minScore = 1
    else
        if winner$(board$) = "tie" then
            minScore = 0
        else
            if winner$(board$) = "" then
                'return minimum of sucessors
                minScore = findMin(board$, maxPlayer$, alpha, beta)
            else
                minScore = -1
            end if
        end if
    end if
end function

function findMin(board$, player$, alpha, beta)
    'board$ = nthword$(tree$(node), 1, ",")
    if player$ = "X" then
        successors$ = successors$(board$, "O")
    else
        successors$ = successors$(board$, "X")
    end if
    nsuccessors = val(nthword$(successors$, 0, ","))
    findMin = 1000
    for i = 1 to nsuccessors
        findMin = min(findMin, maxScore(nthword$(successors$, i, ","), player$, alpha, beta)) 'maximize the min score
        if findMin <= alpha then exit function 'return findMin
        beta = min(beta, findMin)
        'print "    " + str$(score) + " " + nthword$(successors$, i, ",")
        'if score < findMin then
        '    'findMin$ =  nthword$(successors$, i, ",")
        '    findMin = score
        'end if
    next i
end function

'returns the score of a max node
function maxScore(board$, maxPlayer$, alpha, beta)
    if winner$(board$) = maxPlayer$ then
        maxScore = 1
    else
        if winner$(board$) = "tie" then
            maxScore = 0
        else
            if winner$(board$) = "" then
                maxScore = findMax(board$, maxPlayer$, alpha, beta)
            else
                maxScore = -1
            end if
        end if
    end if
end function

function min(n1, n2)
    min = n1
    if n2 < n1 then min = n2
end function

function max(n1, n2)
    max = n1
    if n2 > n1 then max = n2
end function







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



