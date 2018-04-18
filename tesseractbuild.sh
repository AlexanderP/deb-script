#!/bin/bash

#set -x

green() { echo -e "\e[1;32m$1\e[0;39;49m"; }
red() { echo -e "\e[1;31m$1\e[0;39;49m"; }
error(){
    red "Error! $1"
    exit 1
}

#--------------------------------Переменные-----------------------------

export DEBFULLNAME="Ivan Petrov"                # gpg name
export DEBEMAIL="example@mail.ru"               # gpg mail 
PPANAME=test                                    #name ppa in dput.cf
DIST_PPA="trusty xenial artful bionic"          #Distributions for assembly in PPA and pbuilder
DIST_DEB="jessie stretch buster sid"            #Distributions for assembly in PPA and pbuilder
PDIR=${HOME}/pbuilder                           #Path pbulder dir
DIR1="${HOME}/tesseract-build"                  #Build dir

while getopts "d:uptlj:c" Option
do
    case $Option in
        d) DISTRIB=$OPTARG ;;              #Specifying build distributions
        u) UPDATEI=1 ;;                    #pbulder update
        p) PPA_BUILD=1 ;;                  #Build in PPA.
        l) UBUNTUBUILD=1 ;;                #Build ubuntu dist in pbuilder
        j) PARALLEL2=$OPTARG ;;            #number of threads assembly
        c) CREATE=1 ;;                     #Creating the pbuilder environment
    esac
done
shift $((OPTIND - 1))

DIR=$DIR1/reps                      
ORIGDIR=${DIR}/OrigSource 
BUILDDIR=$DIR1/build                
DEBDIR=$DIR1/deb-result             
SOURCEDIR=$DEBDIR/source
LOGDIR=$DIR1/log                    
LOGFILE=$LOGDIR/log                 
LOGFILE1=$LOGDIR/logp
DSCDIR=$DIR/dsc-file                
LINTIANDIR=$DIR1/lintianlog

test -d $BUILDDIR || mkdir -p $BUILDDIR
test -d $DIR || mkdir -p $DIR
test -d $LOGDIR || mkdir -p $LOGDIR
test -d $DEBDIR || mkdir -p $DEBDIR
test -d $SOURCEDIR || mkdir -p $SOURCEDIR
test -d $ORIGDIR || mkdir -p $ORIGDIR
test -d $LINTIANDIR || mkdir -p $LINTIANDIR

if [ -z $PPA_BUILD ]
then
test -d $PDIR || error "path to the working directory of pbuilder is incorrectly set"
fi
touch $LOGFILE

sourceclean(){
    find . -depth -depth -type d -name .svn -exec rm -rf \{\} \;
    find . -depth -depth -type d -name .git -exec rm -rf \{\} \;
    find . -depth -depth -type d -name .hg -exec rm -rf \{\} \;
    find . -depth -depth -type d -name .bzr -exec rm -rf \{\} \;
    find . -depth -depth -type f -name .hgtags -exec rm -rf \{\} \;
    find . -depth -depth -type f -iname "*.pyc" -exec rm -rf \{\} \;
}

createorighqgit(){
    testorig
    cp -r ${DIR}/${PKG_NAME}-debian/debian $BUILDDIR/${PKG_NAME}-${VERSION1}${SVNGITBZR}${dat}/debian
    if [ ! -f "${ORIGDIR}/${ORIGTAR}" ] 
    then
    case ${PKG_NAME} in
        tesseract-*)
            mkdir "$BUILDDIR/${PKG_NAME}-${VERSION1}${SVNGITBZR}${dat}/debian/patches"
            cp -f ${DIFFTMP} "$BUILDDIR/${PKG_NAME}-${VERSION1}${SVNGITBZR}${dat}/debian/patches/ChangeLog.diff"
            echo ChangeLog.diff > "$BUILDDIR/${PKG_NAME}-${VERSION1}${SVNGITBZR}${dat}/debian/patches/series"
        ;;
    esac
    fi
    cd $BUILDDIR/${PKG_NAME}-${VERSION1}${SVNGITBZR}${dat}/
    OLDCOMMIT=$(cat debian/changelog |grep '* Commit' | sed 1q |awk -F ': ' '{print $2}')
    OLDCOMMIT7=$(echo $OLDCOMMIT | cut -c 1-7)
    LINE=$(cat $GITTMPFILE | grep -n $OLDCOMMIT7 | sed 1q |awk -F ':' '{print $1}')
    dch -v "${VERSION}${SVNGITBZR}${dat}-1" -D "unstable" --force-distribution "Compile"
    dch -a "URL: $(echo $GITREPS | sed 's/.*git\:/git\:/g' | sed 's/.*http/http/g' | awk '{print $1}')"
    dch -a "Branch: $branch"
    dch -a "Commit: $commit"
    dch -a "Date: $datct"
    if [ ! -z $OLDCOMMIT ]
    then
    dch -a "git changelog:"
    var0=1
    LIMIT=$(($LINE))
    while [ "$var0" -lt "$LIMIT" ]
    do
        dch -a "	$(cat $GITTMPFILE  | sed 1q)"
        sed -i '1 d' $GITTMPFILE
        var0=$(($var0+1))
    done
    fi
}

testorig(){

ORIGTAR=${PKG_NAME}_${VERSION1}${SVNGITBZR}${dat}.orig.tar.xz

if [ -f "${ORIGDIR}/${ORIGTAR}" ] 
then
    green "orig.tar.xz уже создан."
    rm -fr $BUILDDIR/${PKG_NAME}-${VERSION1}*
    rm -fr $BUILDDIR/${PKG_NAME}_${VERSION1}*
    cp "${ORIGDIR}/${ORIGTAR}" ${BUILDDIR}/
    cd ${BUILDDIR}
    tar xJf "${BUILDDIR}/${ORIGTAR}"
else
    cd $DIR
    rm -fr $BUILDDIR/${PKG_NAME}-${VERSION1}*
    rm -fr $BUILDDIR/${PKG_NAME}_${VERSION1}*
    case ${PKG_NAME} in
        aegisub|tesseract|mypaint|libmypaint|audacity)
            cd "$BUILDDIR" && git clone --depth=10 "${GITREPS}" "${PKG_NAME}-${VERSION1}${SVNGITBZR}${dat}"
        ;;
        tesseract-*)
        rsync -rpav -c --delete-during --progress --exclude-from ${EXCLUDE} ${PKG_NAME}/ "$BUILDDIR/${PKG_NAME}-${VERSION1}${SVNGITBZR}${dat}"
        cp "${GITCLTMPFILE}" "$BUILDDIR/${PKG_NAME}-${VERSION1}${SVNGITBZR}${dat}/ChangeLog"
        DIFFTMP=$(mktemp)
        cd "$BUILDDIR"
cat > ${DIFFTMP} << EOF
Description: Add git ChangeLog
Author: ${DEBFULLNAME} ${DEBEMAIL}
Last-Update: 2018-02-17

$(diff -Naur /dev/null "${PKG_NAME}-${VERSION1}${SVNGITBZR}${dat}/ChangeLog")

EOF
        ;;
    esac
    test -d "$BUILDDIR/${PKG_NAME}-${VERSION1}${SVNGITBZR}${dat}/debian" && rm -fr "$BUILDDIR/${PKG_NAME}-${VERSION1}${SVNGITBZR}${dat}/debian"
    case ${PKG_NAME} in
        tesseract)
            echo "sourceclean disabled"
        ;;
        *)
            sourceclean
        ;;
    esac
        tar -cpf "${PKG_NAME}_${VERSION1}${SVNGITBZR}${dat}.orig.tar" "${PKG_NAME}-${VERSION1}${SVNGITBZR}${dat}"
        xz -9 "${PKG_NAME}_${VERSION1}${SVNGITBZR}${dat}.orig.tar"
fi

}

gitupdate(){
    if [ -d "$DIR/${PKG_NAME}/.git" ]
    then
        cd "$DIR/${PKG_NAME}/" || error
        git pull || error
    else
        cd "$DIR" || error
        git clone $GITREPS ${PKG_NAME} || error
        cd "$DIR/${PKG_NAME}/"
    fi
    
    abbrevcommit=$(git log -1 --abbrev-commit | grep -i "^commit" | awk '{print $2}')
    numcommit=$(git log | grep "^Date:" | wc -l)
    dat="${numcommit}-${abbrevcommit}"
    case ${PKG_NAME} in
        tesseract-*)
            GITCLTMPFILE=$(mktemp)
            cat >> ${GITCLTMPFILE} << EOF
$(git log --date="short" --no-merges --pretty=format:"%cd - %s (commit: %h)")

EOF
                ;;
    esac
    GITTMPFILE=$(mktemp)
    branch=$(git branch | grep "\*" | sed 's/\* //g')
    commit=$(git log -1 | grep -i "^commit" | awk '{print $2}')
    datct=$(git log -n 1 --format=%ct)
    tag=$(git describe --tags --dirty)
    git log -1000 --pretty=format:"%h - %s" > $GITTMPFILE
}

build_it () {
    local OLDDIR=`pwd`
    local SOURCE=$(dpkg-parsechangelog | awk '/^Source: / {print $2}')
    local a=$(date +%s)
    local DIST=$1
    local  ARCH="amd64"
    local tmplogfile="/tmp/$SOURCE-$DIST-$ARCH-$(date +%Y%m%d-%s).log"
    local tmplintianfile="$LINTIANDIR/$SOURCE-$DIST-$ARCH.lintian"
    DIST=$1 ARCH="amd64" pdebuild 2>&1 | tee $tmplogfile
    local ext=$(cat $tmplogfile | grep "Failed autobuilding" | wc -l)
    local ext2=$(cat $tmplogfile | grep "FAILED" | wc -l)
    local ext3=$(cat $tmplogfile | grep "pbuilder-satisfydepends failed" | wc -l)
    local b=$(date +%s)
    local time=$((b-a))
    cd $PDIR/${DIST}-${ARCH}/result || error
    test -f ${ORIGTAR} || cp ${BUILDDIR}/${ORIGTAR} .
    test -f $SOURCE*.changes && lintian -IE --pedantic $SOURCE*.changes 2>&1 | sort -u > $tmplintianfile
    if [ -f $tmplintianfile ]
    then
    local ERROR=$(cat $tmplintianfile | grep -i "^E:" | grep -v lzma | wc -l)
    local WARNING=$(cat $tmplintianfile | grep -i "^W:" | grep -v lzma | wc -l)
    fi
    if [[ $ext != "0" ]]
    then
        red "$(date +'%Y.%m.%d %H:%M:%S') - Error. Package: $SOURCE  Distribution: ${DIST} Architecture: ${ARCH} Build time: $time"
        echo "$(date +'%Y.%m.%d %H:%M:%S') - Error. Package: $SOURCE  Distribution: ${DIST} Architecture: ${ARCH} Build time: $time" >> $LOGFILE
        ext4=1
    elif [[ $ext2 != "0" ]]
    then
        red "$(date +'%Y.%m.%d %H:%M:%S') - Patch Error. Package: $SOURCE  Distribution: ${DIST} Architecture: ${ARCH} Build time: $time"
        echo "$(date +'%Y.%m.%d %H:%M:%S') - Patch Error. Package: $SOURCE  Distribution: ${DIST} Architecture: ${ARCH} Build time: $time" >> $LOGFILE
        ext4=1
    elif [[ $ext3 != "0" ]]
    then
        red "$(date +'%Y.%m.%d %H:%M:%S') - Dependency Error. Package: $SOURCE  Distribution: ${DIST} Architecture: ${ARCH} Build time: $time"
        echo "$(date +'%Y.%m.%d %H:%M:%S') - Dependency Error. Package: $SOURCE  Distribution: ${DIST} Architecture: ${ARCH} Build time: $time" >> $LOGFILE
        ext4=1
    else
        green "$(date +'%Y.%m.%d %H:%M:%S') - Package: $SOURCE  Distribution: ${DIST} Architecture: ${ARCH} Build time: $time W:${WARNING} E:${ERROR}"
        echo "$(date +'%Y.%m.%d %H:%M:%S') - Package: $SOURCE  Distribution: ${DIST} Architecture: ${ARCH} Build time: $time W:${WARNING} E:${ERROR}" >> $LOGFILE
        echo "${SOURCE}	${DIST}	${PARALLEL}	${ARCH}	${time}" >> $LOGFILE1
        ext4=0
    fi
    find . -name "*.deb" -exec rename "s/${ARCH}.deb/${DIST}_${ARCH}.deb/g" \{\} \;
    find . -name "*.deb" -exec rename "s/all.deb/${DIST}_all.deb/g" \{\} \;
    if [[ $ext4 = "0" ]]
    then
    mv *.deb $DEBDIR
    cp *.orig*.tar.* $SOURCEDIR
    mv *.debian.tar.* $SOURCEDIR
    mv *.dsc $SOURCEDIR
    test -f *.diff.* && mv *.diff.* $SOURCEDIR
    fi
    if [ ! -f "${ORIGDIR}/${ORIGTAR}" ] 
    then
    mv ${PKG_NAME}_*.orig*.tar.* $ORIGDIR
    fi
    cp $tmplogfile $LOGDIR
    rm -rf *
    cd $OLDDIR
}
build_it_32 () {
    local OLDDIR=`pwd`
    local SOURCE=$(dpkg-parsechangelog | awk '/^Source: / {print $2}')
    local a=$(date +%s)
    local DIST=$1
    local ARCH="i386"
    local tmplogfile="/tmp/$SOURCE-$DIST-$ARCH-$(date +%Y%m%d-%s).log"
    local tmplintianfile="$LINTIANDIR/$SOURCE-$DIST-$ARCH.lintian"
    DIST=$1 ARCH="i386" linux32 pdebuild 2>&1 | tee $tmplogfile
    local ext=$(cat $tmplogfile | grep "Failed autobuilding" | wc -l)
    local ext2=$(cat $tmplogfile | grep "FAILED" | wc -l)
    local ext3=$(cat $tmplogfile | grep "pbuilder-satisfydepends failed" | wc -l)
    local b=$(date +%s)
    local time=$((b-a))
    cd $PDIR/${DIST}-${ARCH}/result || error
    test -f ${ORIGTAR} || cp ${BUILDDIR}/${ORIGTAR} .
    test -f $SOURCE*.changes && lintian -IE --pedantic $SOURCE*.changes 2>&1 | sort -u > $tmplintianfile
    if [ -f $tmplintianfile ]
    then
    local ERROR=$(cat $tmplintianfile | grep -i "^E:" | grep -v lzma | wc -l)
    local WARNING=$(cat $tmplintianfile | grep -i "^W:" | grep -v lzma | wc -l)
    fi
    if [[ $ext != "0" ]]
    then
        red "$(date +'%Y.%m.%d %H:%M:%S') - Error. Package: $SOURCE  Distribution: ${DIST} Architecture: ${ARCH} Build time: $time"
        echo "$(date +'%Y.%m.%d %H:%M:%S') - Error. Package: $SOURCE  Distribution: ${DIST} Architecture: ${ARCH} Build time: $time" >> $LOGFILE
        ext4=1
    elif [[ $ext2 != "0" ]]
    then
        red "$(date +'%Y.%m.%d %H:%M:%S') - Patch Error. Package: $SOURCE  Distribution: ${DIST} Architecture: ${ARCH} Build time: $time"
        echo "$(date +'%Y.%m.%d %H:%M:%S') - Patch Error. Package: $SOURCE  Distribution: ${DIST} Architecture: ${ARCH} Build time: $time" >> $LOGFILE
        ext4=1
    elif [[ $ext3 != "0" ]]
    then
        red "$(date +'%Y.%m.%d %H:%M:%S') - Dependency Error. Package: $SOURCE  Distribution: ${DIST} Architecture: ${ARCH} Build time: $time"
        echo "$(date +'%Y.%m.%d %H:%M:%S') - Dependency Error. Package: $SOURCE  Distribution: ${DIST} Architecture: ${ARCH} Build time: $time" >> $LOGFILE
        ext4=1
    else
        green "$(date +'%Y.%m.%d %H:%M:%S') - Package: $SOURCE  Distribution: ${DIST} Architecture: ${ARCH} Build time: $time W:${WARNING} E:${ERROR}"
        echo "$(date +'%Y.%m.%d %H:%M:%S') - Package: $SOURCE  Distribution: ${DIST} Architecture: ${ARCH} Build time: $time W:${WARNING} E:${ERROR}" >> $LOGFILE
        echo "${SOURCE}	${DIST}	${PARALLEL}	${ARCH}	${time}" >> $LOGFILE1
        ext4=0
    fi
    find . -name "*.deb" -exec rename "s/${ARCH}.deb/${DIST}_${ARCH}.deb/g" \{\} \;
    find . -name "*.deb" -exec rename "s/all.deb/${DIST}_all.deb/g" \{\} \;
    if [[ $ext4 = "0" ]]
    then
    mv *.deb $DEBDIR
    cp *.orig*.tar.* $SOURCEDIR
    mv *.debian.tar.* $SOURCEDIR
    mv *.dsc $SOURCEDIR
    test -f *.diff.* && mv *.diff.* $SOURCEDIR
    fi
    if [ ! -f "${ORIGDIR}/${ORIGTAR}" ] 
    then
    mv ${PKG_NAME}_*.orig*.tar.* $ORIGDIR
    fi
    cp $tmplogfile $LOGDIR
    rm -rf *
    cd $OLDDIR
}

build(){
    if [ -z    $PPA_BUILD ]
    then
        parallelbuild
        for d in ${DISTRIBUTIONS}
        do
            amd64i386 ${d}
        done
    else
        ppa_pkg
    fi
}

amd64i386(){
            cd ${BUILDDIR}
            cd ${PKG_NAME}-${VERSION1}*
            if [ $(cat debian/control | grep "^Architecture" | grep "any" | sort -u | wc -l) -eq 1 ]
                then
                    build_it_32 $1 && build_it $1
                else
                    build_it_32 $1
            fi
}

parallelbuild(){

if [ -z $PARALLEL2 ]
    then
        DEBFLAGS="parallel=2"
        export DEB_BUILD_OPTIONS="$DEBFLAGS"
    else
        PARALLEL=${PARALLEL2}
        DEBFLAGS="parallel=${PARALLEL}"
        export DEB_BUILD_OPTIONS="$DEBFLAGS"
fi

}
dscgit(){
    PKG_NAME=tesseract-debian
    GITREPS="https://github.com/AlexanderP/tesseract-debian.git"
    gitupdate
    PKG_NAME=tesseract-lang-debian
    GITREPS="https://github.com/AlexanderP/tesseract-lang-debian.git"
    gitupdate
}
dist(){
    if [ -z "$DISTRIB" ]
    then
        DISTRIBUTIONS="${DIST_DEB}"
    else
        DISTRIBUTIONS="$DISTRIB"
    fi
    if [ ! -z "$UBUNTUBUILD" ]
    then
        DISTRIBUTIONS="$DISTRIBUTIONS ${DIST_PPA}"
    fi
    green "$(date +'%Y.%m.%d %H:%M:%S') - Build the package $PKG_NAME for distributions $DISTRIBUTIONS"
}
update_it () {
if [ -z "$DISTRIB" ]
then
    DISTRIBUTIONS="${DIST_DEB} ${DIST_PPA}"
else
    DISTRIBUTIONS="$DISTRIB"
fi
for i in $DISTRIBUTIONS; do
        for j in i386 amd64; do
                export DIST=$i
                export ARCH=$j
                sudo -E pbuilder --update --override-config --configfile ~/.pbuilderrc
                echo "$(date +'%Y.%m.%d %H:%M:%S') - Обновление - $i - $j" >> $LOGFILE
        done
done
}

create_it () {
if [ -z "$DISTRIB" ]
then
    DISTRIBUTIONS="${DIST_DEB} ${DIST_PPA}"
else
    DISTRIBUTIONS="$DISTRIB"
fi
for i in $DISTRIBUTIONS; do
        for j in i386 amd64; do
                export DIST=$i
                export ARCH=$j
                sudo -E pbuilder create --configfile ~/.pbuilderrc
                echo "$(date +'%Y.%m.%d %H:%M:%S') - Создан - $i - $j" >> $LOGFILE
        done
done
}
tesseractgit(){
    PKG_NAME=tesseract
    SVNGITBZR="~git"
    GITREPS="git://github.com/tesseract-ocr/tesseract.git"
    VERSION='4.00'
    DSC_NAME=${PKG_NAME}
    VERSION1=${VERSION}
    dist
    gitupdate
    createorighqgit
    build
}
tesseractlanggit(){
    PKG_NAME=tesseract-lang
    SVNGITBZR="~git"
    GITREPS="https://github.com/tesseract-ocr/tessdata_fast.git"
    VERSION='4.00'
    EXCLUDE=/tmp/${PKG_NAME}_exlude.txt
    DSC_NAME=${PKG_NAME}
    VERSION1=${VERSION}
cat > ${EXCLUDE} << EOF
.git
EOF
    dist
    gitupdate
    createorighqgit
    build
    unset EXCLUDE
}

dist_ppa(){
  if [ -z "$DISTRIB" ]
  then
    DIST="${DIST_PPA}"
  else
    DIST="$DISTRIB"
  fi
  green "Сборка пакета $PKG_NAME под дистрибутивы $DIST"
}
dchppa_pkg(){
for i in ${DIST_PPA}
do
cp -f ${TMPFILE} debian/changelog
dch -b --force-distribution --distribution "$i" -v "${NEW_VER}ppa1~${i}1" \
  "Automated backport upload; no source changes."
[ -z $(echo $SOURCEUP | grep YES) ] && debuild --no-lintian -S -d -sa
[ -z $(echo $SOURCEUP | grep YES) ] || debuild --no-lintian -S -d -sd
SOURCEUP=YES
done
}

ppa_pkg(){
TMPFILE=$(mktemp)
NEW_VER=$(dpkg-parsechangelog | awk '/^Version: / {print $2}')
PKG_NAME=$(dpkg-parsechangelog | awk '/^Source: / {print $2}')
cp debian/changelog ${TMPFILE}

if [ -z "${DIST_PPA}" ] 
then
	dist_ppa
	DIST_PPA=${DIST} 
fi

dchppa_pkg

unset SOURCEUP

for i in ${DIST_PPA}
do
dput ${PPANAME} ../${PKG_NAME}_*${i}1_source.changes
sleep 3
done
cp -f ${TMPFILE} debian/changelog

unset DIST_PPA
if [ ! -f "${ORIGDIR}/${PKG_NAME}_${VERSION1}${SVNGITBZR}${dat}.orig.tar.xz" ] 
then
cp ../${PKG_NAME}_*.orig*.tar.* $ORIGDIR
fi
}

if [ ! -z "$UPDATEI" ]
then
    update_it
    exit 0
fi

if [ ! -z "$CREATE" ]
then
    create_it
    exit 0
fi

dscgit

#tesseractgit
#tesseractlanggit

