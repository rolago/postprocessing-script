# postprocessing-script  rolagoproc.pl

Perl script for post-processing g-code files.

This script automatically processes g-code files in order to compensate for layers shift, both in X and Y directions.
Besides, a scaling feature has been recently added, in order to grow/shrink 3d objects in X and Y dir.
The script is named "rolagoproc.pl" .
In Repetier Host, you have to declare its precise pathname in menu 
Printer Settings -> Advanced as in the following example:

"perl C:\Users\alfa\Desktop\3dpostproc\rolagoproc.pl  #out

In this way, the script is executed after each slicing action 
and operates a filtering on the g-code produced by the slicer (slic3r).

The parameters to be modified into rolagoproc.pl are grouped into two categories:

1) Layers shifting (typical case of slanted 3d objects)
2) Scaling vs X or Y directions

As an example, see the following settings, that fit all right for my 3d-delta printer:

FOR LAYER SHIFTING COMPENSATION:

 my $CRX = -0.002;      # $CRX  growing and negative, makes left shifting
 my $CRY = 0.00;        # $CRY  growing and negative, makes forward shifting
 
 FOR SCALING OBJECT X-Y DIMENSIONS:
 
 my $XSCALE = 1.006;         # x scaling factor
 my $YSCALE = 0.986;         # y scaling factor
 

In the message window of Repetier, You'll see these messages:

22:23:28.513 : <Postprocess> ===== Starting rolago proc ===== 
22:23:28.513 : <Postprocess> ===== Ending rolago proc ===== 

The script modifies the Repetier system file C:\Users\alfa\AppData\Local\RepetierHost\composition.gcode
so that , at the end of its execution, You can view directly the new g-code model into the Slicer Window of Repetier.






