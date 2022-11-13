#!/bin/bash
#------------------------------
# Download OpenLB 1.5 and Complier
# test.
# example:
# load OpenLB env
# cd $path_OpenLB
# mv config.mk config/
# cp config/cpu_gcc_openmpi.mk config.mk
# cd examples/particles/settlingCube3d/
# make
# mpirun -np ./settlingCube3d
# The output file in the tmp folder.
# You can open it with Paraview.
#-------------------------------

read -p "Input directory for download package and uncompress package--->" openlbdir

cd $openlbdir
wget https://www.openlb.net/wp-content/uploads/2022/04/olb-1.5r0.tgz

if [ -f "olb-1.5r0.tgz" ];then
     true
else echo "olb-1.5r.tgz not downloaded!"
     exit 1
fi

if [ ! -n "$openlbdir" ];then
     echo "Erro: not a valid directory."
     exit 1
fi

if [ ! -d "$openlbdir" ];then
     echo "Erro: no permission or not a valid directory."
     exit 1
fi

tar -zxvf olb-1.5r0.tgz
cd olb-1.5r0/

function complier_cputest(){
     mv config.mk config/
     cp config/cpu_gcc_openmpi.mk config.mk
     module load gcc-9.5.0
     module load openmpi-4.1.4
     cd $openlbdir/olb-1.5r0/examples/particles/settlingCube3d/
     make
     read -p "Input core number--->" cnum
     if [[ "$cnum" =~ ^\+?[1-9][0-9]*$ ]];then
     mpirun -np $cnum $openlbdir/olb-1.5r0/examples/particles/settlingCube3d/settlingCube3d
     else echo "Erro,Core number is integer!"
     exit 1
     fi
}

complier_cputest
