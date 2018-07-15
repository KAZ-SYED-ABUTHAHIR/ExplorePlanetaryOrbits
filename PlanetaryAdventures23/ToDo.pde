/*

*  Display LRL Vector
*  Incorporate Verlet Integration  - From Iteration 23 - This is a mess why? 
   /* Problem Solved ! Most Important thing in Verlet Integration is that deltaTime should be a constant ...
    If not the numerical integral would diverge.
    One disadvantage is that deltaTime can't be made to depend on frameRate. 
    Hence leading to varying speed of animated objects. But this problem can be remedied by averaging over two 
    consequent frameRates I hope.



*/
