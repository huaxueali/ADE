#!/bin/bash
#------------------------------------
# Use module to load environment,
## yum -y install environment-modules
## Add "source /usr/share/Modules/init/bash" at the end of the /etc/profile
#------------------------------------

wget https://ftp.gnu.org/gnu/gcc/gcc-9.5.0/gcc-9.5.0.tar.gz

if [ -f "gcc-9.5.0.tar.gz" ];then
     true
else echo "gcc-9.5.0.tar.gz not downloaded!"
     exit 1
fi
gcc1=`gcc -dumpversion | awk '{split($0,a,"."); print a[1]}'`

if [ $gcc1 -gt 9 ];then
     echo "GCC version is higher than 9, no need to install gcc-9.5"
     exit 1
fi

read -p "Input installation directory for gcc-9.5.0--->" gcc9dir
read -p "Input modulefiles directory--->" moduledir

if [ ! -n "$gcc9dir" ]; then
     echo "Erro: not a valid directory.";
     exit 1
fi
mkdir -p $gcc9dir

if [ ! -d "$gcc9dir" ]; then
     echo "Erro: no permission or not a valid directory."
     exit 1
fi

function install_gcc(){
     echo "uncompress gcc-9.5.0.tar.gz and installing..."
     tar -zxvf gcc-9.5.0.tar.gz
     cd gcc-9.5.0
     ./contrib/download_prerequisites
     mkdir build && cd build/
     ./../configure --prefix=$gcc9dir --disable-multilib --enable-bootstrap --enable-checking=release
     make -j 4
     make install 
     
}

install_gcc

touch $moduledir/gcc-9.5.0


echo "#%Module1.0" >> $moduledir/gcc-9.5.0
echo "##" >> $moduledir/gcc-9.5.0
echo "##" >> $moduledir/gcc-9.5.0

echo "set GCC \"$gcc9dir\"" >> $moduledir/gcc-9.5.0
echo "prepend-path PATH \"\$GCC/bin\"" >> $moduledir/gcc-9.5.0
echo "prepend-path LD_LIBRARY_PATH \"\$GCC/lib\"" >> $moduledir/gcc-9.5.0
echo "prepend-path LD_LIBRARY_PATH \"\$GCC/lib64\"" >> $moduledir/gcc-9.5.0
echo "prepend-path LD_LIBRARY_PATH \"\$GCC/libexec\"" >> $moduledir/gcc-9.5.0
echo "prepend-path INCLUDE \"\$GCC/lib\"" >> $moduledir/gcc-9.5.0
echo "prepend-path CPATH \"\$GCC/include\"" >> $moduledir/gcc-9.5.0
echo "prepend-path MANPATH \"\$GCC/share/man\"" >> $moduledir/gcc-9.5.0


echo "Complete!"

