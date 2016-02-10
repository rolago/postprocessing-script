# postprocessing-script  rolagoproc.pl
# by Agostino Rolando
# Vers. 2.0 , 21 jan 2016

# Perl script for post-processing g-code files.
#This script automatically processes g-code files in order to compensate for layers shift, #both in X and Y directions.
#Besides, a scaling feature has been recently added, in order to grow/shrink 3d objects in #X and Y dir.
#In Repetier Host, you have to declare its pathname in menu 
# Printer Settings -> Advanced as in the following example:
#"perl C:\Users\alfa\Desktop\3dpostproc\rolagoproc.pl  #out
#The script is executed after #each slicing action 
#and operates a filtering on the g-code produced by the slicer (slic3r).

#!/usr/bin/perl -i.bak

use strict;
use warnings;
use English '-no_match_vars';
use File::Copy qw/ move /;

 my $F = 0;
 my $E = 0;
 my ($X,$Y);
 my $fatx =0;
 my $faty =0;

 # These are parameters

 my $CRX = -0.002;     # $CRX  growing and negative, makes left shifting
 my $CRY = 0.00;        # $CRY  growing and negative, makes forward shifting
 
my $XSCALE = 1.006;         # x scaling factor
my $YSCALE = 0.986;         # y scaling factor
 
 #my $filename = 'C:\Users\alfa\Desktop\3dpostproc\report.gcode';
  my $filename = 'C:\Users\alfa\AppData\Local\RepetierHost\mycomposition.gcode';
  my $filename2 = 'C:\Users\alfa\AppData\Local\RepetierHost\composition.gcode';

 open(FILE , ">$filename");
 
 print  "===== Starting Rolago Proc ===== \n";
 
 while (<>) 
 {
  
  if (/^G1 Z/) 
    {
    
      $fatx = $fatx + $CRX;
      $faty = $faty +$CRY;
    }
    
    
  if (/^M84/)   
    {                      
       print FILE  "G1 X-40 Y40 Z210 F500  ; move head away from the object \n";  # move head away from the object
       print FILE  "M106 S125 ; enable fan \n";  # enable fan
    }
   
  
  if (/^G1 Z0 F5000/)    # prior to lift nozzle..
    {                              # ..enable autoleveling
       print FILE  "G29 ; enable autoleveling\n";  
      
    }  
 
if (/^M109 S200/)    # prior to wait for temperature to be reached..
    {                              # ..enable fan
       print FILE  "M106 S200 ; enable fan\n";  
      
    }  

    
    if (/^G1 X([0123456789,-.]+) Y([0123456789,-.]+).*? E([0-9.]+) F([0-9.]+)/) 
    {    
        my ($x, $y, $e, $f) = ($1, $2, $3, $4);
                
        $E = $e;
        $X = $x;
        $Y = $y;
        $F = $f;
      
        my $newx = ($X+$fatx)*$XSCALE;
        my $newy = ($Y+$faty)*$YSCALE;
        
        printf ( FILE "G1 X%5.3f",$newx ); 
        printf ( FILE "  Y%5.3f", $newy ); 
        printf ( FILE " E%5.3f",$e ); 
        printf ( FILE " F%5.3f",$f ); 
        printf ( FILE "\n" );  
          
    }
       else 
       {
        if (/^G1 X([0123456789,-.]+) Y([0123456789,-.]+).*? E([0-9.]+)/) 
         {    
          my ($x, $y, $e) = ($1, $2, $3);
                
          $E = $e;
          $X = $x;
          $Y = $y;  
      
          my $newx = ($X+$fatx)*$XSCALE;
          my $newy = ($Y+$faty)*$YSCALE;
           
          printf ( FILE "G1 X%5.3f",$newx ); 
          printf ( FILE "  Y%5.3f", $newy ); 
          printf ( FILE " E%5.3f",$e ); 
          printf ( FILE "\n" );  

         }
        
         else 
         {
         if (/^G1 X([0123456789,-.]+) Y([0123456789,-.]+).*? F([0-9.]+)/) 
          {    
          my ($x, $y, $f) = ($1, $2, $3);
                
          $F = $f;
          $X = $x;
          $Y = $y;  
      
          my $newx = ($X+$fatx)*$XSCALE;
          my $newy = ($Y+$faty)*$YSCALE;
           
          printf ( FILE  "G1 X%5.3f",$newx);
          printf ( FILE  "  Y%5.3f", $newy);
          printf ( FILE  " F%5.3f",$f);
          printf ( FILE  "\n" ); 
          }
                                
          else 
           {
           # nothing interesting, print line as-is
           print FILE  or die $!;
           }
      } 
  }
 }

close FILE;
move( $filename, $filename2 );
print  "===== Ending Rolago Proc ===== \n";
