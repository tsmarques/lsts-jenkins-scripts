#!/bin/bash

a6xx="geode-lsts-linux-gnu-"
a9xx="armv7-lsts-linux-gnueabi-"
b2xx="armv7-lsts-linux-gnueabi-"
rpi="armv7-lsts-linux-gnueabihf-"
auxrpi="armv7-lsts-linux-gnueabihf-"
atom="atom64-lsts-linux-gnu-"

work_dir=$1
target_system=$2
branch=$3
src_dir=$4
on_demand=$5

if [ -z "$branch" ]; then
    branch='master'
fi

if [ -z "$src_dir" ]; then
    src_dir=../$target_system
fi

cd $work_dir && rm -rf ./$target_system

# final package
sys_package=dune-*.tar.bz2

# build directory for this system
build_dir="../build"-$target_system

# toolchain used to cross-compile
toolchain_dir=/home/lsts/jenkins/base/$target_system/bin/${!target_system}

# where to put the compiled package into
if [ -z "$on_demand" ]; then
    factory_dir="/home/lsts/jenkins/factory/requests/dune/$branch/$target_system"
else
    factory_dir="/home/lsts/jenkins/factory/dune/$branch/$target_system"
fi


# number of cores
n_cores=$(grep -c ^processor /proc/cpuinfo)

rm -rf $build_dir && mkdir -p $build_dir
mkdir -p $factory_dir

echo "***************************"
echo "******* Build info *******"
echo "* current dir: $(pwd)"
echo "* target: $target_system"
echo "** build dir: $build_dir"
echo "** src dir: $src_dir"
echo "** toolchain: $toolchain_dir"
echo "** sys package: $sys_package"
echo "** factory dir: $factory_dir"
echo "***************************"
echo "***************************"

cd $build_dir && cmake -DCROSS=$toolchain_dir $src_dir && make -j $n_cores package && cp $sys_package $factory_dir
