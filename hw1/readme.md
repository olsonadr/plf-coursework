## Usage

This compiles without issue on a local version of GHCi 8.6.5 and online hosted on [repl.it](https://repl.it/@olsonadr/plf-coursework-7). While in the same directory as main.hs, the command used is:
``` bash
ghci main.hs
```


## Notes

Several auxilliary functions were used to help implement the requirements.

Three test functions exist, which output True for each case if the functions returned what we expected. These functions print titles for what they are testing, but these might not match the case or spelling of the actual functions being called:
- gr_test          (tests graph functions)
- sh_test          (tests shape functions)
- bg_test          (tests bag functions)


## Assumptions:

- Shapes
  - The coordinates of the Shape functions represent an (x,y) pair in the first quadrant of a typical plotting space, where lower x coordinates (including negative positions) are left of higher x coordinates, and lower y coordinates (including negative positions) are below higher y coordinates
  - The point in the Circle data type represents the center of the circle
  - The point in the Rect data type represents the lower-left corner of the rectangle
  - The points of a bouning-box represent the lower-left and upper-right corners of the bbox
  - A shape may be inside itself as the edge of a shape is still part of a shape (less-than-or-equal rather than less-than comparisons)
  - Because the function "alignLeft" does not specify to what X value the shapes should be aligned to, it can be assumed that the furthest-left edge of all the shapes in the figure can be used. Regardless, the function is successful if all have the same minX result, regardless of what it is
- Graphs
  - The successors of a Node N1 are all Nodes that are destinations of Edges starting at the N1 ( the edges \[ (N1,N2), (N1,N3), (N4,N1) \] indicate that N1 has successors [N2, N3] but not N4).