#!/bin/bash

set -e
lib_path="../../lib/"

source ${lib_path}path.sh
source ${lib_path}util.sh
source ${lib_path}upload_handler.sh

root_dir=$(pwd)
package_name=$(get_runner)
version=2.8.1
arch=$(uname -m)
source_dir=${root_dir}/${package_name}-src
build_dir=${root_dir}/${package_name}-build
bin_dir=${root_dir}/${package_name}

clone https://github.com/rheit/zdoom.git ${source_dir}
cd $source_dir
git checkout $version

mkdir -p $build_dir
cd $build_dir
cmake $source_dir
make -j$(getconf _NPROCESSORS_ONLN)

mkdir -p ${bin_dir}
mv zdoom zdoom.pk3 ${bin_dir}
cd ${bin_dir}
strip zdoom

cd ${root_dir}
dest_file="${package_name}-${version}-${arch}.tar.gz"
tar czf ${dest_file} ${package_name}
rm -rf $bin_dir $source_dir $build_dir
runner_upload ${package_name} ${version} ${arch} ${dest_file}
