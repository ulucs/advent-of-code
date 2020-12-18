module Main where

import Day.Lex
import Day.Par
import Day.Abs
import Day.ErrM
import Utils
 
type Err = Either String
type Result = Integer

transLine :: Line -> [Result]
transLine x = case x of
  ELines exp line -> (transExp exp):(transLine line)
  Line1Exp exp -> (transExp exp):[]
  Line1Line line -> transLine line
  Line1_ -> []
transExp :: Exp -> Result
transExp x = case x of
  EAdd exp1 exp2 -> (transExp exp1) + transExp exp2
  EMul exp1 exp2 -> (transExp exp1) * transExp exp2
  EInt integer -> integer

main = do
  inp <- Utils.getInput "18"
  print $ calc inp
 
calc inp = sum $ transLine e
  where Ok e = pLine (myLexer s) 

