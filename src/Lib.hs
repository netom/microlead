{-# LANGUAGE RecordWildCards #-}

module Lib
    ( someFunc
    ) where

data Role
    = Leader
    | Candidate
    | Follower

-- start: follower
-- time out, start election: follower -> candidate
-- time out, new election: candidate -> candidate
-- received majority of votes: candidate -> leader
-- step down: leader -> follower
-- discover current leader or higher term: candidate -> follower

-- Time is divided to Terms
-- terms increment eternally

-- each node has a "current term" value

type Term = Integer

data Message
    = VoteRequest
        { nodeId :: Integer
        , term :: Term
        }
    | Vote
        { nodeId:: Integer
        , term :: Term
        , voteGranted :: Bool
        }

data NodeState = NodeState
    { currentTerm :: Term
    , voted :: Bool
    , role :: Role
    }

startState = NodeState 0 True Follower

-- node process:
-- listen on TChan for Messages
-- start as Follower, term = 0, voted = True
-- if timeout, hold an election ("election process?" Control.Concurrent.Timer?)
-- every received message updates current term (oneShotRestart?)
-- every message updates the current term
-- no vote is given in term 0

-- Follower:
-- passive, only listens

-- ElectionTimeout: 100-500ms

-- Election:
-- increment current term
-- convert from follower to:

-- Candidate:
-- vote for self
-- send VoteRequests, retry until
-- * receives majority vote: converts to leader
-- * receives VR from leader: steps down, beacomes follower
-- * no-one wins the election

-- Leader:
-- Sends out HeartBeat messages more frequently than the ElectionTimeout

-- each node SHOULD only give one vote per term
-- persisting to disk is important for crash recovery in vanilla raft
-- ??? other option: no votes given in 0th term at all ???
--   and requests for proper elections, so terms has a hard real-time limit
-- election timeout must be spread out between [T, 2T] (election timeout)

-- Hooks:
-- leader
-- stepDown

someFunc :: IO ()
someFunc = putStrLn "someFunc"
