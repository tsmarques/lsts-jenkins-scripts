#!/bin/bash

work_dir=$1
target_system=$2
branch=$3
sha1=$4

if [ -z "$branch" ]; then
    branch='master'
fi

cd $work_dir && rm -rf ./target_system

# e.g. separate into [lctr-a6xx, lauv-noptilus-1]
sys_info=($(echo $target_system | sed -e 's:/: :g'))

# e.g. lctr-a6xx/lauv-noptilus-1.bash
sys_file="$target_system".bash

# e.g lauv-noptilus-1
sys_name="${sys_info[1]}"

# final package
sys_package=${sys_info[0]}/glued-*.tar.bz2

if [ -z "$on_demand" ]; then
    factory_dir="/home/lsts/jenkins/factory/requests/glued/$branch/$target_system"
else
    factory_dir="/home/lsts/jenkins/factory/glued/$branch/$target_system"
fi

mkdir -p $factory_dir


# Docker run configuration
## user ID
uid=`id -u $USER`
## group ID
gid=`id -g $USER`
## docker volume
volume="$work_dir:$work_dir"
## which container to run
container="jenkins"
## used for downloads
dns_addr="10.0.0.1"
## glued compilation pipeline

echo "****************"
echo "* Build Options "
echo "** work_dir: $work_dir"
echo "** target_system: $target_system"
echo "** branch: $branch"
echo "** sha1: $sha1"
echo "** factory_dir: $factory_dir"
echo "****************"

docker run -u $uid:$gid -w $work_dir -v $volume --dns=$dns_addr -t $container /bin/bash -c "./mkconfig.bash $sys_name && ./mksystem.bash $sys_file && ./pkrootfs.bash $sys_file"

# store artifacts
echo "Copying package $sys_package into $factory_dir"
cp -rf $sys_package $factory_dir
