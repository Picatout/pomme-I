  NEW 
    1 ' fibonacci
   20 X = 1 : Y = 1 
   30 IF X < 0  THEN 100 
   40 PRINT X; 
   50 X = X + Y 
   60 IF  Y < 0  THEN 100 
   70 PRINT Y; 
   80 Y = X + Y 
   90 GOTO 30 
  100 END 
