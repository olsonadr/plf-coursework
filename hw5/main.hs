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
-- 1 { int x;                      -- [x:?] start 1st block
-- 2   int y;                      -- [y:?,x:?]
-- 3   y := 1;                     -- [y:1,x:?]
-- 4   { int f(int x) { ... };     -- [f:{},y:1,x:?] start 2nd block, f() definition
-- -- jumping back to 4 for execution of f(2)
-- 4     int f(int x) {            -- [x:2,f:{},y:1,x:?]
-- 5       if x=0 then { ... }     -- [x:2,f:{},y:1,x:?]
-- 7       else {                  -- [x:2,f:{},y:1,x:?]
-- -- jumping back to 4 for execution of f(1)
-- 4     int f(int x) {            -- [x:1,x:2,f:{},y:1,x:?]
-- 5       if x=0 then { ... }     -- [x:1,x:2,f:{},y:1,x:?]
-- 7       else {                  -- [x:1,x:2,f:{},y:1,x:?]
-- -- jumping back to 4 for execution of f(0)
-- 4     int f(int x) {            -- [x:0,x:1,x:2,f:{},y:1,x:?]
-- 5       if x=0 then {           -- [x:0,x:1,x:2,f:{},y:1,x:?]
-- 6           y := 1 }            -- [x:0,x:1,x:2,f:{},y:1,x:?]
-- 7       else { ... };           -- [x:0,x:1,x:2,f:{},y:1,x:?]
-- 9       return y;               -- [res:1,x:0,x:1,x:2,f:{},y:1,x:?]
-- 10    };                        -- [x:1,x:2,f:{},y:2,x:?]
-- -- jumping up a level to 8 (in execution of f(1))
-- 8           y := f(x-1)*y+1 };  -- [x:1,x:2,f:{},y:2,x:?]
-- 9       return y;               -- [res:2,x:1,x:2,f:{},y:2,x:?]
-- 10    };                        -- [x:2,f:{},y:2,x:?]
-- -- jumping up a level to 8 (in execution of f(2))
-- 8           y := f(x-1)*y+1 };  -- [x:2,f:{},y:5,x:?]
-- 9       return y;               -- [res:5,x:2,f:{},y:5,x:?]
-- 10    };                        -- [f:{},y:5,x:?]
-- -- after end of f(2)
-- 11    x := f(2);                -- [f:{},y:1,x:5]
-- 12  };                          -- [y:1,x:5]
-- 13 }                            -- []

ex1_sol = "-- -- exercise 1 solution (runtime stacks)\n1 { int x;                      -- [x:?] start 1st block\n2   int y;                      -- [y:?,x:?]\n3   y := 1;                     -- [y:1,x:?]\n4   { int f(int x) { ... };     -- [f:{},y:1,x:?] start 2nd block, f() definition\n-- jumping back to 4 for execution of f(2)\n4     int f(int x) {            -- [x:2,f:{},y:1,x:?]\n5       if x=0 then { ... }     -- [x:2,f:{},y:1,x:?]\n7       else {                  -- [x:2,f:{},y:1,x:?]\n-- jumping back to 4 for execution of f(1)\n4     int f(int x) {            -- [x:1,x:2,f:{},y:1,x:?]\n5       if x=0 then { ... }     -- [x:1,x:2,f:{},y:1,x:?]\n7       else {                  -- [x:1,x:2,f:{},y:1,x:?]\n-- jumping back to 4 for execution of f(0)\n4     int f(int x) {            -- [x:0,x:1,x:2,f:{},y:1,x:?]\n5       if x=0 then {           -- [x:0,x:1,x:2,f:{},y:1,x:?]\n6           y := 1 }            -- [x:0,x:1,x:2,f:{},y:1,x:?]\n7       else { ... };           -- [x:0,x:1,x:2,f:{},y:1,x:?]\n9       return y;               -- [res:1,x:0,x:1,x:2,f:{},y:1,x:?]\n10    };                        -- [x:1,x:2,f:{},y:2,x:?]\n-- jumping up a level to 8 (in execution of f(1))\n8           y := f(x-1)*y+1 };  -- [x:1,x:2,f:{},y:2,x:?]\n9       return y;               -- [res:2,x:1,x:2,f:{},y:2,x:?]\n10    };                        -- [x:2,f:{},y:2,x:?]\n-- jumping up a level to 8 (in execution of f(2))\n8           y := f(x-1)*y+1 };  -- [x:2,f:{},y:5,x:?]\n9       return y;               -- [res:5,x:2,f:{},y:5,x:?]\n10    };                        -- [f:{},y:5,x:?]\n-- after end of f(2)\n11    x := f(2);                -- [f:{},y:1,x:5]\n12  };                          -- [y:1,x:5]\n13 }                            -- []\n\n"




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

-- -- -- exercise 2 trace (STATIC SCOPING)
-- 1 { int x;                              -- [x:?]
-- 2   int y;                              -- [y:?,x:?]
-- 3   int z;                              -- [z:?,y:?,x:?]
-- 4   x := 3;                             -- [z:?,y:?,x:3]
-- 5   y := 7;                             -- [z:?,y:7,x:3]
-- 6   { int f(int y) { return x*y };      -- [f:{},z:?,y:7,x:3]
-- 7     int y;                            -- [y:?,f:{},z:?,y:7,x:3]
-- 8     y := 11;                          -- [y:11,f:{},z:?,y:7,x:3]
-- 9     { int g(int x) { return f(y) };   -- [g:{},y:11,f:{},z:?,y:7,x:3]
-- 10      { int y;                        -- [y:?,g:{},y:11,f:{},z:?,y:7,x:3]
-- 11        y := 13;                      -- [y:13,g:{},y:11,f:{},z:?,y:7,x:3]
-- -- jump to 6 for execution of f(11) in execution of g(2)
-- 6   { int f(int y) { return x*y };      -- [res:33,y:11,f:{},z:?,y:7,x:3]
-- -- jump to 9 for execution of g(2)
-- 9     { int g(int x) { return f(y) };   -- [res:33,x:2,g:{},y:11,f:{},z:?,y:7,x:3]
-- -- jump to 12 after execution of g(2)
-- 12        z := g(2);                    -- [y:13,g:{},y:11,f:{},z:33,y:7,x:3]
-- 13      };                              -- [g:{},y:11,f:{},z:33,y:7,x:3]
-- 14    };                                -- [y:11,f:{},z:33,y:7,x:3]
-- 15  };                                  -- [z:33,y:7,x:3]
-- 16 }                                    -- []
-- 
-- -- -- exercise 2 trace (DYNAMIC SCOPING)
-- 1 { int x;                              -- [x:?]
-- 2   int y;                              -- [y:?,x:?]
-- 3   int z;                              -- [z:?,y:?,x:?]
-- 4   x := 3;                             -- [z:?,y:?,x:3]
-- 5   y := 7;                             -- [z:?,y:7,x:3]
-- 6   { int f(int y) { return x*y };      -- [f:{},z:?,y:7,x:3]
-- 7     int y;                            -- [y:?,f:{},z:?,y:7,x:3]
-- 8     y := 11;                          -- [y:11,f:{},z:?,y:7,x:3]
-- 9     { int g(int x) { return f(y) };   -- [g:{},y:11,f:{},z:?,y:7,x:3]
-- 10      { int y;                        -- [y:?,g:{},y:11,f:{},z:?,y:7,x:3]
-- 11        y := 13;                      -- [y:13,g:{},y:11,f:{},z:?,y:7,x:3]
-- -- jump to 6 for execution of f(13) in execution of g(2)
-- 6   { int f(int y) { return x*y };      -- [resf:26,y:13,x:2,y:13,g:{},y:11,f:{},z:?,y:7,x:3]
-- -- jump to 9 for execution of g(2)
-- 9     { int g(int x) { return f(y) };   -- [resg:26,x:2,y:13,g:{},y:11,f:{},z:?,y:7,x:3]
-- -- jump to 12 after execution of g(2)
-- 12        z := g(2);                    -- [y:13,g:{},y:11,f:{},z:26,y:7,x:3]
-- 13      };                              -- [g:{},y:11,f:{},z:26,y:7,x:3]
-- 14    };                                -- [y:11,f:{},z:26,y:7,x:3]
-- 15  };                                  -- [z:26,y:7,x:3]
-- 16 }                                    -- []

ex2_trace = "-- -- exercise 2 trace (STATIC SCOPING)\n1 { int x;                              -- [x:?]\n2   int y;                              -- [y:?,x:?]\n3   int z;                              -- [z:?,y:?,x:?]\n4   x := 3;                             -- [z:?,y:?,x:3]\n5   y := 7;                             -- [z:?,y:7,x:3]\n6   { int f(int y) { return x*y };      -- [f:{},z:?,y:7,x:3]\n7     int y;                            -- [y:?,f:{},z:?,y:7,x:3]\n8     y := 11;                          -- [y:11,f:{},z:?,y:7,x:3]\n9     { int g(int x) { return f(y) };   -- [g:{},y:11,f:{},z:?,y:7,x:3]\n10      { int y;                        -- [y:?,g:{},y:11,f:{},z:?,y:7,x:3]\n11        y := 13;                      -- [y:13,g:{},y:11,f:{},z:?,y:7,x:3]\n-- jump to 6 for execution of f(11) in execution of g(2)\n6   { int f(int y) { return x*y };      -- [res:33,y:11,f:{},z:?,y:7,x:3]\n-- jump to 9 for execution of g(2)\n9     { int g(int x) { return f(y) };   -- [res:33,x:2,g:{},y:11,f:{},z:?,y:7,x:3]\n-- jump to 12 after execution of g(2)\n12        z := g(2);                    -- [y:13,g:{},y:11,f:{},z:33,y:7,x:3]\n13      };                              -- [g:{},y:11,f:{},z:33,y:7,x:3]\n14    };                                -- [y:11,f:{},z:33,y:7,x:3]\n15  };                                  -- [z:33,y:7,x:3]\n16 }                                    -- []\n\n-- -- exercise 2 trace (DYNAMIC SCOPING)\n1 { int x;                              -- [x:?]\n2   int y;                              -- [y:?,x:?]\n3   int z;                              -- [z:?,y:?,x:?]\n4   x := 3;                             -- [z:?,y:?,x:3]\n5   y := 7;                             -- [z:?,y:7,x:3]\n6   { int f(int y) { return x*y };      -- [f:{},z:?,y:7,x:3]\n7     int y;                            -- [y:?,f:{},z:?,y:7,x:3]\n8     y := 11;                          -- [y:11,f:{},z:?,y:7,x:3]\n9     { int g(int x) { return f(y) };   -- [g:{},y:11,f:{},z:?,y:7,x:3]\n10      { int y;                        -- [y:?,g:{},y:11,f:{},z:?,y:7,x:3]\n11        y := 13;                      -- [y:13,g:{},y:11,f:{},z:?,y:7,x:3]\n-- jump to 6 for execution of f(13) in execution of g(2)\n6   { int f(int y) { return x*y };      -- [resf:26,y:13,x:2,y:13,g:{},y:11,f:{},z:?,y:7,x:3]\n-- jump to 9 for execution of g(2)\n9     { int g(int x) { return f(y) };   -- [resg:26,x:2,y:13,g:{},y:11,f:{},z:?,y:7,x:3]\n-- jump to 12 after execution of g(2)\n12        z := g(2);                    -- [y:13,g:{},y:11,f:{},z:26,y:7,x:3]\n13      };                              -- [g:{},y:11,f:{},z:26,y:7,x:3]\n14    };                                -- [y:11,f:{},z:26,y:7,x:3]\n15  };                                  -- [z:26,y:7,x:3]\n16 }                                    -- []\n"

-- -- -- exercise 2 solutions (value assigned to z in line 12)
-- -- (a) under static scoping
-- 12 z := 33
-- -- (b) under dynamic scoping
-- 12 z := 26
ex2_sol = "-- -- exercise 2 solutions (value assigned to z in line 12)\n-- (a) under static scoping\n12 z := 33\n-- (b) under dynamic scoping\n12 z := 26\n"




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


-- -- -- exercise 3 trace (CALL BY NAME)
-- 1 { int y;              -- [y:?]
-- 2   int z;              -- [z:?,y:?]
-- 3   y := 7;             -- [z:?,y:7]
-- 4   { int f(int a) { }; -- [f:{},z:?,y:7]
-- 8     int g(int x) { }; -- [g:{},f:{},z:?,y:7]
-- -- jump back to 8 for execution of g(<y*2>)
-- 8     int g(int x) {    -- [x:<y*2>,g:{},f:{},z:?,y:7]
-- -- jump back to 4 for execution of f(<x+1>)
-- 4   { int f(int a) {    -- [a:<x+1>,x:<y*2>,g:{},f:{},z:?,y:7]
-- 5       y := a+1;       -- [a:<x+1>,x:<y*2>,g:{},f:{},z:?,y:16]
-- 6       return (y+a)    -- [resf:49,a:<x+1>,x:<y*2>,g:{},f:{},z:?,y:16]
-- 7     };                -- [x:<y*2>,g:{},f:{},z:?,y:16]
-- -- jump back to 9 after execution of f(<x+1>)
-- 9       y := f(x+1)+1;   [x:<y*2>,g:{},f:{},z:?,y:50]
-- -- jump back to 4 for execution of f(<x-y+3>)
-- 4   { int f(int a) {    -- [a:<x-y+3>,x:<y*2>,g:{},f:{},z:?,y:50]
-- 5       y := a+1;       -- [a:<x-y+3>,x:<y*2>,g:{},f:{},z:?,y:54]
-- 6       return (y+a)    -- [resf:111,a:<x-y+3>,x:<y*2>,g:{},f:{},z:?,y:54]
-- 7     };                -- [x:<y*2>,g:{},f:{},z:?,y:54]
-- -- jump back to 10 after execution of f(<x-y+3>)
-- 10      z := f(x-y+3);  -- [x:<y*2>,g:{},f:{},z:111,y:54]
-- 11      return (z+1)    -- [resg:112,x:<y*2>,g:{},f:{},z:111,y:54]
-- 12    }                 -- [g:{},f:{},z:111,y:54]
-- -- jump back to 13 after execution of g(<y*2>)
-- 13    z := g(y*2);      -- [g:{},f:{},z:112,y:54]
-- 14  };                  -- [z:112,y:54]
-- 15 }                    -- []
-- 
-- -- -- exercise 3 trace (CALL BY NEED)
-- 1 { int y;              -- [y:?]
-- 2   int z;              -- [z:?,y:?]
-- 3   y := 7;             -- [z:?,y:7]
-- 4   { int f(int a) { }; -- [f:{},z:?,y:7]
-- 8     int g(int x) { }; -- [g:{},f:{},z:?,y:7]
-- -- jump back to 8 for execution of g(<y*2>)
-- 8     int g(int x) {    -- [x:<y*2>,g:{},f:{},z:?,y:7]
-- -- jump back to 4 for execution of f(<x+1>)
-- 4   { int f(int a) {    -- [a:<x+1>,x:<y*2>,g:{},f:{},z:?,y:7]
-- 5       y := a+1;       -- [a:15,x:14,g:{},f:{},z:?,y:16]
-- 6       return (y+a)    -- [resf:31,a:15,x:14,g:{},f:{},z:?,y:16]
-- 7     };                -- [x:14,g:{},f:{},z:?,y:16]
-- -- jump back to 9 after execution of f(<x+1>)
-- 9       y := f(x+1)+1;  -- [x:14,g:{},f:{},z:?,y:32]
-- -- jump back to 4 for execution of f(<x-y+3>)
-- 4   { int f(int a) {    -- [a:<x-y+3>,x:14,g:{},f:{},z:?,y:32]
-- 5       y := a+1;       -- [a:-15,x:14,g:{},f:{},z:?,y:-14]
-- 6       return (y+a)    -- [resf:-29,a:-15,x:14,g:{},f:{},z:?,y:-14]
-- 7     };                -- [x:14,g:{},f:{},z:?,y:-14]
-- -- jump back to 10 after execution of f(<x-y+3>)
-- 10      z := f(x-y+3);  -- [x:14,g:{},f:{},z:-29,y:-14]
-- 11      return (z+1)    -- [resg:-28,x:14,g:{},f:{},z:-29,y:-14]
-- 12    }                 -- [g:{},f:{},z:-29,y:-14]
-- -- jump back to 13 after execution of g(<y*2>)
-- 13    z := g(y*2);      -- [g:{},f:{},z:-28,y:-14]
-- 14  };                  -- [z:-28,y:-14]
-- 15 }                    -- []

ex3_trace = "-- -- exercise 3 trace (CALL BY NAME)\n1 { int y;              -- [y:?]\n2   int z;              -- [z:?,y:?]\n3   y := 7;             -- [z:?,y:7]\n4   { int f(int a) { }; -- [f:{},z:?,y:7]\n8     int g(int x) { }; -- [g:{},f:{},z:?,y:7]\n-- jump back to 8 for execution of g(<y*2>)\n8     int g(int x) {    -- [x:<y*2>,g:{},f:{},z:?,y:7]\n-- jump back to 4 for execution of f(<x+1>)\n4   { int f(int a) {    -- [a:<x+1>,x:<y*2>,g:{},f:{},z:?,y:7]\n5       y := a+1;       -- [a:<x+1>,x:<y*2>,g:{},f:{},z:?,y:16]\n6       return (y+a)    -- [resf:49,a:<x+1>,x:<y*2>,g:{},f:{},z:?,y:16]\n7     };                -- [x:<y*2>,g:{},f:{},z:?,y:16]\n-- jump back to 9 after execution of f(<x+1>)\n9       y := f(x+1)+1;  -- [x:<y*2>,g:{},f:{},z:?,y:50]\n-- jump back to 4 for execution of f(<x-y+3>)\n4   { int f(int a) {    -- [a:<x-y+3>,x:<y*2>,g:{},f:{},z:?,y:50]\n5       y := a+1;       -- [a:<x-y+3>,x:<y*2>,g:{},f:{},z:?,y:54]\n6       return (y+a)    -- [resf:111,a:<x-y+3>,x:<y*2>,g:{},f:{},z:?,y:54]\n7     };                -- [x:<y*2>,g:{},f:{},z:?,y:54]\n-- jump back to 10 after execution of f(<x-y+3>)\n10      z := f(x-y+3);  -- [x:<y*2>,g:{},f:{},z:111,y:54]\n11      return (z+1)    -- [resg:112,x:<y*2>,g:{},f:{},z:111,y:54]\n12    }                 -- [g:{},f:{},z:111,y:54]\n-- jump back to 13 after execution of g(<y*2>)\n13    z := g(y*2);      -- [g:{},f:{},z:112,y:54]\n14  };                  -- [z:112,y:54]\n15 }                    -- []\n\n-- -- exercise 3 trace (CALL BY NEED)\n1 { int y;              -- [y:?]\n2   int z;              -- [z:?,y:?]\n3   y := 7;             -- [z:?,y:7]\n4   { int f(int a) { }; -- [f:{},z:?,y:7]\n8     int g(int x) { }; -- [g:{},f:{},z:?,y:7]\n-- jump back to 8 for execution of g(<y*2>)\n8     int g(int x) {    -- [x:<y*2>,g:{},f:{},z:?,y:7]\n-- jump back to 4 for execution of f(<x+1>)\n4   { int f(int a) {    -- [a:<x+1>,x:<y*2>,g:{},f:{},z:?,y:7]\n5       y := a+1;       -- [a:15,x:14,g:{},f:{},z:?,y:16]\n6       return (y+a)    -- [resf:31,a:15,x:14,g:{},f:{},z:?,y:16]\n7     };                -- [x:14,g:{},f:{},z:?,y:16]\n-- jump back to 9 after execution of f(<x+1>)\n9       y := f(x+1)+1;  -- [x:14,g:{},f:{},z:?,y:32]\n-- jump back to 4 for execution of f(<x-y+3>)\n4   { int f(int a) {    -- [a:<x-y+3>,x:14,g:{},f:{},z:?,y:32]\n5       y := a+1;       -- [a:-15,x:14,g:{},f:{},z:?,y:-14]\n6       return (y+a)    -- [resf:-29,a:-15,x:14,g:{},f:{},z:?,y:-14]\n7     };                -- [x:14,g:{},f:{},z:?,y:-14]\n-- jump back to 10 after execution of f(<x-y+3>)\n10      z := f(x-y+3);  -- [x:14,g:{},f:{},z:-29,y:-14]\n11      return (z+1)    -- [resg:-28,x:14,g:{},f:{},z:-29,y:-14]\n12    }                 -- [g:{},f:{},z:-29,y:-14]\n-- jump back to 13 after execution of g(<y*2>)\n13    z := g(y*2);      -- [g:{},f:{},z:-28,y:-14]\n14  };                  -- [z:-28,y:-14]\n15 }                    -- []\n"

-- -- -- exercise 3 solutions (values of y and z at end of block)
-- -- (a) using call-by-name parameter passing
-- y:54, z:112
-- -- (b) using call-by-need parameter passing
-- y:-14, z:-28

ex3_sol = "-- -- exercise 3 solutions (values of y and z at end of block)\n-- (a) using call-by-name parameter passing\ny:54, z:112\n-- (b) using call-by-need parameter passing\ny:-14, z:-28\n"



-- -- -- -- main function (print answers)
main = do
    putStrLn "\n\n"
    putStrLn (ex1 ++ "\n" ++ ex1_sol ++ "\n\n\n")
    putStrLn (ex2 ++ "\n" ++ ex2_trace ++ "\n" ++ ex2_sol ++ "\n\n\n")
    putStrLn (ex3 ++ "\n" ++ ex3_trace ++ "\n" ++ ex3_sol ++ "\n\n\n")