TARGET_DIR=`pwd`
#复制指定目录内的res、src到本地根据时间戳生成的文件内
FILE_DIR=$1
TIME_STR=`date +%Y%m%d%H`
DONE_DIR=${TARGET_DIR}/${TIME_STR} #输出目录

mkdir -p ${DONE_DIR}/res
mkdir -p ${DONE_DIR}/src
cp -R ${FILE_DIR}/res/* ${DONE_DIR}/res/
cp -R ${FILE_DIR}/src/* ${DONE_DIR}/src/

echo "copy file end----"

#加密当前时间戳目录内res、src的文件
sh build.sh ${DONE_DIR} ${TIME_STR}