TARGET_DIR=`pwd`
#复制指定目录内的res、src到本地根据时间戳生成的文件内
FILE_DIR=$1
TIME_STR=update_`date +%Y%m%d%H`
DONE_DIR=${TARGET_DIR}/${TIME_STR} #输出目录

mkdir -p ${DONE_DIR}/res
mkdir -p ${DONE_DIR}/src
cp -R ${FILE_DIR}/res/* ${DONE_DIR}/res/
cp -R ${FILE_DIR}/src/* ${DONE_DIR}/src/

echo "copy file end----"

#加密当前时间戳目录内res、src的文件
sh build.sh ${DONE_DIR} ${TIME_STR}

#根据生成的文件计算MD5 然后与上一次的比较、找出md5不一致的文件，并存放在TIME_STR目录下
#并且产生一个TIME_STR.zip压缩包
OLD_FILE=$2 #旧的md5文件
TMP_DIR=${TIME_STR}/${TIME_STR}
SPE_FILE=${TMP_DIR}_spe.md5 #额外差异的md5文件

function fnCheckMd5()
{
    for path in `find $1 -type d`
    do
        local dirname=`echo "$path" | awk -F '.' '{print $2}' `
        for filepath in `find $path -type f -depth 1`
        do
            local filetype=`echo "$filepath" | awk -F '.' '{print $NF}' `
            if [ ${filetype} != "DS_Store" ]
            then
                local md5Name=`echo \`md5 ${filepath}\``
                local key=`echo "$md5Name" | awk '{split($0,a,"[()]");print a[2]}'`
                key=`echo "$key" "${DONE_DIR}/" | awk '{gsub($2,"");print $NF}'` #删掉前面的的路径字符串
                local value=`echo "$md5Name" | awk -F ' ' '{print $NF}' ` #按照空格截取最后的字符
                # echo ${key}=${value} >>${TMP_DIR}.md5 #追加方式存储 覆盖用>
                local isHave=`grep "${key}=${value}" ${OLD_FILE}`
                if [ "${isHave}" == "" ]
                then
                    echo ${key}=${value} >>${SPE_FILE} #追加方式存储 覆盖用>
                    local dpath=`echo ${key%/*}`
                    mkdir -p ${TMP_DIR}/${dpath}
                    cp ${TIME_STR}/${key} ${TMP_DIR}/${dpath}/
                    # echo "new file:"${dpath}
                fi
            fi
        done
    done
}
fnCheckMd5 "${DONE_DIR}/res"
fnCheckMd5 "${DONE_DIR}/src"
if [ -f ${SPE_FILE} ]
then
    cd ${TIME_STR}
    zip -r ${TIME_STR}.zip ${TIME_STR}/*
    echo "zip is done"
    echo `md5 ${TIME_STR}.zip`
fi
echo "end----"

