#!/bin/bash
#------------------------------
# Openmpi-4.1.4
#------------------------------

read -p "Input directory for download package--->" dwpath
read -p "Input installation directory for openmpi-4.1.4--->" openmpdir
read -p "Input modulefiles directory--->" moduledir

wget -P $dwpath https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.4.tar.gz

cd $dwpath

if [ -f "openmpi-4.1.4.tar.gz" ];then
     true
else echo "openmpi-4.1.4.tar.gz not downloaded!"
     exit 1
fi

if [ ! -n "$openmpdir" ];then
     echo "Erro: not a valid directory."
     exit 1
fi

if [ ! -d "$openmpdir" ];then
     echo "Erro: no permission or not a valid directory."
     exit 1
fi 

function install_opmp(){
     echo "uncompress openmpi-4.1.4.tar.gz and installing..."
     tar -zxvf openmpi-4.1.4.tar.gz
     cd openmpi-4.1.4
     mkdir build && cd build
     ./../configure --prefix=$openmpdir
     make all install

}

install_opmp

mod_name="openmpi-4.1.4"
touch $moduledir/$mod_name

echo "#%Module1.0" >> $moduledir/$mod_name
echo "##" >> $moduledir/$mod_name
echo "##" >> $moduledir/$mod_name

echo "set MPI \"$openmpdir\"" >> $moduledir/$mod_name
echo "prepend-path PATH \"\$MPI/bin\"" >> $moduledir/$mod_name
echo "prepend-path LD_LIBRARY_PATH \"\$MPI/lib\"" >> $moduledir/$mod_name
echo "prepend-path INCLUDE \"\$MPI/include\"" >> $moduledir/$mod_name
echo "prepend-path CPATH \"\$MPI/include\"" >> $moduledir/$mod_name
echo "prepend-path MANPATH \"\$MPI/share/man\"" >> $moduledir/$mod_name

echo "Complete!"
