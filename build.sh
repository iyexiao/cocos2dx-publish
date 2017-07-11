# 接受传入参数
FILE_DIR=$1
OUT_FILE=$2

# 临时生成文件目录
RES_DIR="${FILE_DIR}/res"
SRC_DIR="${FILE_DIR}/src"
KEY="KFCKey"
#加密png、jpg、ccz、lua文件
function xxtRes()
{
    for path in `find $1 -type d`
    do
        local dirname=`echo "$path" | awk -F '.' '{print $2}' `
        for filepath in `find $path -type f -depth 1`
        do
            local filename=`echo "$filepath" | awk -F '.' '{print $1}' `
            local filetype=`echo "$filepath" | awk -F '.' '{print $NF}' `
            filename=`echo "$filename" "${FILE_DIR}/" | awk '{gsub($2,"");print $NF}'` #删掉前面的的路径字符串
            if [ $filename != "src/main" ] #src/main.lua不加密
            then
                if [ $filetype == "png" -o $filetype == "ccz" -o $filetype == "jpg" -o $filetype == "lua" ]
                then
                    ./xxteaRes ${filepath} ${KEY}
                fi
            fi
        done
    done
}
xxtRes "${SRC_DIR}"
xxtRes "${RES_DIR}"

function fnMd5()
{
    for path in `find $1 -type d`
    do
        local dirname=`echo "$path" | awk -F '.' '{print $2}' `
        for filepath in `find $path -type f -depth 1`
        do
            # local filename=`echo "$filepath" | awk -F '.' '{print $1}' `
            local filetype=`echo "$filepath" | awk -F '.' '{print $NF}' `
            if [ $filetype != "DS_Store" ]
            then
                local md5Name=`echo \`md5 ${filepath}\``
                local key=`echo "$md5Name" | awk '{split($0,a,"[()]");print a[2]}'`
                key=`echo "$key" "${FILE_DIR}/" | awk '{gsub($2,"");print $NF}'` #删掉前面的的路径字符串
                local value=`echo "$md5Name" | awk -F ' ' '{print $NF}' ` #按照空格截取最后的字符
                echo ${key}=${value} >>${OUT_FILE}/${OUT_FILE}.md5 #追加方式存储 覆盖用>
            fi
        done
    done
}
fnMd5 "${SRC_DIR}"
fnMd5 "${RES_DIR}"

echo "build success----"