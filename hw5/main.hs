module HW4 where

-- -- -- -- excercise 1

-- -- -- exercise 1 given block
-- 1 { int x;                      -- start 1st block
-- 2   int y;
-- 3   y := 1;
-- 4   { int f(int x) {            -- start 2nd block, start f() function
-- 5       if x=0 then {
-- 6           y := 1 }
-- 7       else {
-- 8           y := f(x-1)*y+1 };
-- 9       return y;
-- 10    };                        -- end f() function
-- 11    x := f(2);
-- 12  };                          -- end 2nd block
-- 13 }                            -- end 1st block
ex1 = "-- -- exercise 1 given block\n1 { int x;                      -- start 1st block\n2   int y;\n3   y := 1;\n4   { int f(int x) {            -- start 2nd block, start f() function\n5       if x=0 then {\n6           y := 1 }\n7       else {\n8           y := f(x-1)*y+1 };\n9       return y;\n10    };                        -- end f() function\n11    x := f(2);\n12  };                          -- end 2nd block\n13 }                            -- end 1st block\n"


-- -- -- exercise 1 solution (runtime stacks)
-- 1
-- ...
ex1_sol = "-- -- exercise 1 solution (runtime stacks)\n1\n..."




-- -- -- -- excercise 2

-- -- -- exercise 2 given block
-- 1 { int x;                              -- start 1st block
-- 2   int y;
-- 3   int z;
-- 4   x := 3;
-- 5   y := 7;
-- 6   { int f(int y) { return x*y };      -- start 2nd block, full f() function
-- 7     int y;
-- 8     y := 11;
-- 9     { int g(int x) { return f(y) };   -- start 3rd block, full g() function
-- 10      { int y;                        -- start 4th block
-- 11        y := 13;
-- 12        z := g(2);
-- 13      };                              -- end 4th block
-- 14    };                                -- end 3rd block
-- 15  };                                  -- end 2nd block
-- 16 }                                    -- end 1st block

ex2 = "-- -- exercise 2 given block\n1 { int x;                              -- start 1st block\n2   int y;\n3   int z;\n4   x := 3;\n5   y := 7;\n6   { int f(int y) { return x*y };      -- start 2nd block, full f() function\n7     int y;\n8     y := 11;\n9     { int g(int x) { return f(y) };   -- start 3rd block, full g() function\n10      { int y;                        -- start 4th block\n11        y := 13;\n12        z := g(2);\n13      };                              -- end 4th block\n14    };                                -- end 3rd block\n15  };                                  -- end 2nd block\n16 }                                    -- end 1st block\n"


-- -- -- exercise 2 solutions (value assigned to z in line 12)
-- -- (a) under static scoping
-- 12 z := ANSWER
-- -- (b) under dynamic scoping
-- 12 z := ANSWER
ex2_sol = "-- -- exercise 2 solutions (value assigned to z in line 12)\n-- (a) under static scoping\n12 z := ANSWER\n-- (b) under dynamic scoping\n12 z := ANSWER"




-- -- -- -- excercise 3

-- -- -- exercise 3 given block
-- 1 { int y;              -- start 1st block
-- 2   int z;
-- 3   y := 7;
-- 4   { int f(int a) {    -- start 2nd block, start f() function
-- 5       y := a+1;
-- 6       return (y+a)
-- 7     };                -- end f() function
-- 8     int g(int x) {    -- start g() function
-- 9       y := f(x+1)+1;
-- 10      z := f(x-y+3);
-- 11      return (z+1)
-- 12    }                 -- end g() function
-- 13    z := g(y*2);
-- 14  };                  -- end 2nd block
-- 15 }                    -- end 1st block

ex3 = "-- -- exercise 3 given block\n1 { int y;              -- start 1st block\n2   int z;\n3   y := 7;\n4   { int f(int a) {    -- start 2nd block, start f() function\n5       y := a+1;\n6       return (y+a)\n7     };                -- end f() function\n8     int g(int x) {    -- start g() function\n9       y := f(x+1)+1;\n10      z := f(x-y+3);\n11      return (z+1)\n12    }                 -- end g() function\n13    z := g(y*2);\n14  };                  -- end 2nd block\n15 }                    -- end 1st block\n"


-- -- -- exercise 3 solutions (values of y and z at end of block)
-- -- (a) using call-by-name parameter passing
-- y:ans, z:ans
-- -- (b) using call-by-need parameter passing
-- y:ans, z:ans

ex3_sol = "-- -- exercise 3 solutions (values of y and z at end of block)\n-- (a) using call-by-name parameter passing\ny:ans, z:ans\n-- (b) using call-by-need parameter passing\ny:ans, z:ans"



-- -- -- -- main function (print answers)
main = do
    putStrLn "\n\n"
    putStrLn (ex1 ++ "\n" ++ ex1_sol ++ "\n\n\n")
    putStrLn (ex2 ++ "\n" ++ ex2_sol ++ "\n\n\n")
    putStrLn (ex3 ++ "\n" ++ ex3_sol ++ "\n\n\n")