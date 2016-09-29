#!/bin/bash

# Default pseudo dir, change according to your needs..
pseudodir=/public/software/vasp/pseudo/PAW_PBE54

# Remove existing POTCAR
rm -f POTCAR

# Create the POTCAR file. Use _pv / _d postfix (more accurate) by default. Change according to your needs...
for elem in `head -n 6 POSCAR | tail -n 1`; do
  if [ -e ${pseudodir}/${elem}_pv/POTCAR ]; then
    potcar=${pseudodir}/${elem}_pv/POTCAR
  elif [ -e ${pseudodir}/${elem}_d/POTCAR ]; then
    potcar=${pseudodir}/${elem}_d/POTCAR
  elif [ -e ${pseudodir}/${elem}/POTCAR ]; then
    potcar=${pseudodir}/${elem}/POTCAR
  else
    echo " !!! FATAL ERROR: pseudopotential for ${elem} was not found in $pseudodir."
    echo "     Make sure the POSCAR is correct and try again."
    echo "     Or manually create it in the old fashion. :)"
  fi
  echo "POTCAR for ${elem} is $potcar."
  cat $potcar >> POTCAR
done

# Find the maximum ENMAX
encut="`awk -F\; '{ print $1;}' POTCAR | grep ENMAX - | awk 'BEGIN {e=0.0;} {if ($3>e) {e=$3;} } END {print e;}' -`"

echo "ENMAX for this POTCAR: ${encut}"
echo " Please test ENCUT before continue;"
echo " Yet in most cases ENMAX*1.5 would be a safe choice."
