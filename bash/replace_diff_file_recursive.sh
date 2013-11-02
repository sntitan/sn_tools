#!/bin/sh

#本脚本的作用是，递归遍历给出的第二个目录中的所有文件，并与第一个目录中对应的文件作比较，如果不同，则把文件从第一个目录覆盖到第二个目录中

function replace_if_diff(){
    if ! cmp -s $1 $2
    then
            echo "copy file" $1 " to " $2
            cp $1 $2
    fi        
}
#$1 src copy floder
#$2 dst copy floder
#$3 root floder
function copy_file_exists(){
        local work_dir cur_dir
        work_dir=$2
        cd ${work_dir}
        for cur_dir in  $(ls ${work_dir})
        do
                if test -d ${cur_dir}; then
                        copy_file_exists $1 ${work_dir}/${cur_dir} $3
                        cd ..
                else
                        tmp_path=${work_dir}/${cur_dir}
                        relative_path=${tmp_path#$3}
                        replace_if_diff $1/${relative_path} $3/${relative_path}
                fi
        done
}
function scan_dir(){
        copy_file_exists $1 $2 $2
}



echo "compare from" $2 "and copy files from" $1 "to it..."
scan_dir $1 $2
