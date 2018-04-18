#!/bin/bash

green() { echo -e "\e[1;32m$1\e[0;39;49m"; }
red() { echo -e "\e[1;31m$1\e[0;39;49m"; }
error(){
    red "Error! $1"
    exit 1
}

REPREPRO_DIR="/media/sdb5/reprepro"

test -d $REPREPRO_DIR || error "Неверно задан путь до рабочей директории reprepro"

DEBIAN_DISTRIB="wheezy jessie stretch buster sid "
UBUNTU_DISTRIB="precise trusty xenial artful"
PPA_UBUNTU="precise trusty wily xenial yakkety zesty"
PPA_UBUNTU_DAY="precise trusty vivid wily"
DISTRIB="${DEBIAN_DISTRIB} ${UBUNTU_DISTRIB}"

PKG_NAME="aegisub audacity azpainter autopano-sift-c balsa bmpanel2 clementine compizboxmenu cuneiform-linux \
deadbeef eiskaltdcpp eiskaltdcpp-unstable fatrat freecad freecad-daily gimp gimp-devel gimp-gtk3 gmic goaccess gscan2pdf keepassxc \
kvirc launchy librecad linuxdcpp llpp muse mypaint myrulib obkey ocrfeeder ocrodjvu pinta psi-plus ppastats \
psi-plus-l10n pytyle q4wine qcad qcomicbook qpxtool qt-box-editor quneiform rubyripper scantailor scantailor-advanced scantailor-universal \
smplayer solvespace sz81 tesseract-ocr truecrypt uget vacuum veracrypt yagf znotes"

OUT_DIR=$(pwd)/out

test -d $OUT_DIR || mkdir -p $OUT_DIR

#NET_INDEX="${OUT_DIR}/index-net_$(date +%Y%m%d).html"
ORG_INDEX="${OUT_DIR}/index-org_$(date +%Y%m%d).html"

#NET_INDEX_RU="${OUT_DIR}/index-ru-net_$(date +%Y%m%d).html"
ORG_INDEX_RU="${OUT_DIR}/index-ru-org_$(date +%Y%m%d).html"

TIMESTAMP=$(date +%s)

touch $NET_INDEX $ORG_INDEX $NET_INDEX_RU $NET_INDEX_RU

for i in $NET_INDEX $ORG_INDEX; do
cat > $i << EOF
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" >
<title>Unofficial repository for Debian/Ubuntu</title>
<style type="text/css">  .record {background-color:#D9DDFF; color:#000000; font-family:MS Sans Serif; font-size:8pt}  .header {background-color:#AAAAEE; color:#FFFFFF; font-weight:bold; font-family:MS Sans Serif; font-size:8pt}  .hrecord {background-color:#CCFFCD; color:#000000; font-family:MS Sans Serif; font-size:8pt}  .hheader {background-color:#68FF64; color:#000000; font-weight:bold; font-family:MS Sans Serif; font-size:8pt} .footer {background-color:#FFFFFF; color:#AAAAEE; font-family:MS Sans Serif; font-size:8pt}</style>
</head>
<table align="right" >
    <tr>
        <td>
            <a href=index-old_ru.html>RU</a>
        </td>
        <td>
            <form action="https://www.paypal.com/cgi-bin/webscr" method="post" target="_top">
            <input type="hidden" name="cmd" value="_s-xclick">
            <input type="hidden" name="hosted_button_id" value="82FDQKGH8L4HU">
            <input type="image" src="https://www.paypalobjects.com/en_US/i/btn/btn_donate_SM.gif" name="submit" alt="PayPal - The safer, easier way to pay online!">
            <img alt="" border="0" src="https://www.paypalobjects.com/en_US/i/scr/pixel.gif" width="1" height="1">
            </form>
        </td>
<!--
        <td>
            <a href="https://flattr.com/submit/auto?user_id=Alex_P&amp;url=http%3A%2F%2Fnotesalexp.org" target="_blank"><img src="//api.flattr.com/button/flattr-badge-large.png" alt="Flattr this" title="Flattr this" border="0"></a>
        </td>
        <td>
            <iframe frameborder="0" allowtransparency="true" scrolling="no" src="https://money.yandex.ru/embed/small.xml?account=410012527124756&amp;quickpay=small&amp;yamoney-payment-type=on&amp;button-text=06&amp;button-size=s&amp;button-color=white&amp;targets=notesalexp.org&amp;default-sum=100&amp;successURL=" width="145" height="31"></iframe>
        </td>
-->
    </tr>
</table>
<dl>
    <DT>Open a terminal<DT>
    <I>su</I> - <FONT COLOR="#808080">#to log as root</FONT><DT>
    <I>gedit /etc/apt/sources.list</I> <FONT COLOR="#808080">#to open
    repository file with a text editor (you can use gedit or another)</FONT><DT>
EOF
done

for i in $NET_INDEX_RU $ORG_INDEX_RU; do
NETORG=$(echo $i | sed 's/_.*//g' | sed 's/.*-//g')
cat > $i << EOF
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" >
<title>Unofficial repository for Debian/Ubuntu</title>
<style type="text/css">  .record {background-color:#D9DDFF; color:#000000; font-family:MS Sans Serif; font-size:8pt}  .header {background-color:#AAAAEE; color:#FFFFFF; font-weight:bold; font-family:MS Sans Serif; font-size:8pt}  .hrecord {background-color:#CCFFCD; color:#000000; font-family:MS Sans Serif; font-size:8pt}  .hheader {background-color:#68FF64; color:#000000; font-weight:bold; font-family:MS Sans Serif; font-size:8pt} .footer {background-color:#FFFFFF; color:#AAAAEE; font-family:MS Sans Serif; font-size:8pt}</style>
</head>
<table align="right" >
    <tr>
        <td>
            <a href="https://notesalexp.${NETORG}/index-old.html">EN</a>
        </td>
        <td>
            <form action="https://www.paypal.com/cgi-bin/webscr" method="post" target="_top">
            <input type="hidden" name="cmd" value="_s-xclick">
            <input type="hidden" name="hosted_button_id" value="82FDQKGH8L4HU">
            <input type="image" src="https://www.paypalobjects.com/en_US/i/btn/btn_donate_SM.gif" name="submit" alt="PayPal - The safer, easier way to pay online!">
            <img alt="" border="0" src="https://www.paypalobjects.com/en_US/i/scr/pixel.gif" width="1" height="1">
            </form>
        </td>
<!--
        <td>
            <a href="https://flattr.com/submit/auto?user_id=Alex_P&amp;url=http%3A%2F%2Fnotesalexp.org" target="_blank"><img src="//api.flattr.com/button/flattr-badge-large.png" alt="Flattr this" title="Flattr this" border="0"></a>
        </td>
        <td>
            <iframe frameborder="0" allowtransparency="true" scrolling="no" src="https://money.yandex.ru/embed/small.xml?account=410012527124756&amp;quickpay=small&amp;yamoney-payment-type=on&amp;button-text=06&amp;button-size=s&amp;button-color=white&amp;targets=notesalexp.org&amp;default-sum=100&amp;successURL=" width="145" height="31"></iframe>
        </td>
-->
    </tr>
</table>
<dl>
    <DT>Откройте терминал<DT>
    <I>su</I> - <FONT COLOR="#808080">#залогиньтесь под root</FONT><DT>
    <I>gedit /etc/apt/sources.list</I> <FONT COLOR="#808080">#Откройте файл sources.list
    с помощью текстового редактора (вы можете использовать gedit или любой другой текстовый редактор)</FONT><DT>
EOF
done


for i in $NET_INDEX $ORG_INDEX; do
	for j in $DISTRIB; do
		NETORG=$(echo $i | sed 's/_.*//g' | sed 's/.*-//g')
		l=$(echo "${j}" | sed 's/\(.\)/\u\1/')
		echo "    Add this line for ${l}:" >> $i
		echo "    <I>deb https://notesalexp.${NETORG}/debian/${j}/ ${j} main</I><DT>" >> $i
	done
done

for i in $NET_INDEX_RU $ORG_INDEX_RU; do
	for j in $DISTRIB; do
		NETORG=$(echo $i | sed 's/_.*//g' | sed 's/.*-//g')
		l=$(echo "${j}" | sed 's/\(.\)/\u\1/')
		echo "    Добавьте следующую строку для ${l}:" >> $i
		echo "    <I>deb https://notesalexp.${NETORG}/debian/${j}/ ${j} main</I><DT>" >> $i
	done
done

for i in $NET_INDEX $ORG_INDEX; do
cat >> $i << EOF
    Save and close sources.list<DT>
EOF
done

for i in $NET_INDEX_RU $ORG_INDEX_RU; do
cat >> $i << EOF
    Сохраните и закройте sources.list<DT>
EOF
done

for i in $NET_INDEX $ORG_INDEX; do
NETORG=$(echo $i | sed 's/_.*//g' | sed 's/.*-//g')
cat >> $i << EOF
    <I>apt-get install apt-transport-https</I><DT>
    <I>apt-get update -oAcquire::AllowInsecureRepositories=true</I><DT>
    <I>apt-get install notesalexp-keyring -oAcquire::AllowInsecureRepositories=true</I><FONT COLOR="#808080"> #to add gpg key</FONT><DT>
    <I>apt-get update</I> <FONT COLOR="#808080">#to update package list</FONT><DT>
    <I>apt-get install package</I><DT>
    <strong>Warning:</strong> Need to update the gpg-key.(2015-09-20)<DT>
    <strong>Warning:</strong> Some packages for Debian GNU/Linux require <a href="http://www.deb-multimedia.org/">http://www.deb-multimedia.org/</a>  repository to be connected.
</dl>
EOF
done

for i in $NET_INDEX_RU $ORG_INDEX_RU; do
NETORG=$(echo $i | sed 's/_.*//g' | sed 's/.*-//g')
cat >> $i << EOF
    <I>apt-get install apt-transport-https</I><DT>
    <I>apt-get update -oAcquire::AllowInsecureRepositories=true</I><DT>
    <I>apt-get install notesalexp-keyring -oAcquire::AllowInsecureRepositories=true</I><FONT COLOR="#808080"> #Добавьте gpg ключ</FONT><DT>
    <I>apt-get update</I> <FONT COLOR="#808080">#Обновите список пакетов</FONT><DT>
    <I>apt-get install пакет</I><DT>
    <strong>Внимание:</strong> Необходимо обновить gpg ключ.(2015-09-20)<DT>
    <strong>Внимание:</strong> Для некоторых пакетов, собранных для системы Debian GNU/Linux, необходимо подключить <a href="http://www.deb-multimedia.org/">http://www.deb-multimedia.org/</a>.
</dl>
EOF
done

for i in $NET_INDEX $ORG_INDEX; do
cat >> $i << EOF
    <table border="0" cellpadding="2" cellspacing="2">
            <tr class="header">
                <td> </td>
                <td> Package\Dist </td>
EOF
done

for i in $NET_INDEX_RU $ORG_INDEX_RU; do
cat >> $i << EOF
    <table border="0" cellpadding="2" cellspacing="2">
            <tr class="header">
                <td> </td>
                <td> Пакет\Система </td>
EOF
done


for i in $NET_INDEX $ORG_INDEX $NET_INDEX_RU $ORG_INDEX_RU; do
	NETORG=$(echo $i | sed 's/_.*//g' | sed 's/.*-//g')
	for j in $DEBIAN_DISTRIB; do
	l=$(echo "${j}" | sed 's/\(.\)/\u\1/')
echo "                <td> <a href=\"https://notesalexp.${NETORG}/${j}/\">Debian ${l}</a></td>" >> $i
	done
	for j in $UBUNTU_DISTRIB; do
	l=$(echo "${j}" | sed 's/\(.\)/\u\1/')
echo "                <td> <a href=\"https://notesalexp.${NETORG}/${j}/\">Ubuntu ${l}</a></td>" >> $i
	done
	echo "                <td> <a href=\"https://notesalexp.${NETORG}/source/\">Source</a></td>" >> $i
	echo "            </tr>" >> $i
done

homepage(){
HOMEPAGES=homepage.txt
DESCTXT=description.txt
if [ ! -z "$(cat ${HOMEPAGES} | grep ${l})" ]
then
	HOMEPAGE=$(cat ${HOMEPAGES} | grep ${l} | sed 1q | awk '{print $2}')
	DEB_HOMEPAGE=$(find ${REPREPRO_DIR} -name "${l}_*.deb" | sed 1q)
else
	DEB_HOMEPAGE=$(find ${REPREPRO_DIR} -name "${l}_*.deb" | sed 1q)
	HOMEPAGE=$(dpkg-deb -I ${DEB_HOMEPAGE}| grep Homepage: | sed 's/.*e: //')
fi
if [ ! -z "$(cat ${DESCTXT} | grep ${l})" ]
then
	DESC=$(cat ${DESCTXT} | grep ${l} | sed 1q | awk -F":" '{print $2}')
else
	DESC=$(dpkg-deb -I ${DEB_HOMEPAGE} | grep Description: | sed 's/.*n: //')
fi
	echo "                <td><strong><a title=\"${DESC}\" href=\"${HOMEPAGE}\"> ${l} </a></strong></td>" >> $i
#	echo "                <td><strong><a href=\"${HOMEPAGE}\"> ${l} </a></strong></td>" >> $i
}

ORG_INDEX_TMP="$(mktemp)index-org_$(date +%Y%m%d).html"
#NET_INDEX_TMP="$(mktemp)index-net_$(date +%Y%m%d).html"
for i in $NET_INDEX_TMP $ORG_INDEX_TMP; do
	N=1
	NETORG=$(echo $i | sed 's/_.*//g' | sed 's/.*-//g')
	for l in $PKG_NAME; do
		echo "            <tr class="record">" >> $i
		echo "                <td> ${N} </td>" >> $i
		homepage
		#echo "                <td> ${l} </td>" >> $i
		case ${l} in
			ocrodjvu|balsa|gscan2pdf|pinta|mypaint|freecad*|qcad|tesseract*|aegisub|kvirc*|clementine|deadbeef|goaccess|ppastats|gimp*|llpp|scantailor*|solvespace|librecad)
			UPVERSION=$(find ${REPREPRO_DIR} -name "${l}_*.deb" ! -name "*wily*" ! -name "*utopic*" | sed 's/_a.*//g'| sed 's/_i.*//g' | sed 's/.*_//g'| sed 's/ppa.*//g' | rev | cut -c 3- | rev | sort -u | tac | sed 1q)
			;;
			*)
			UPVERSION=$(find ${REPREPRO_DIR} -name "${l}_*.deb" ! -name "*wily*" ! -name "*utopic*" | sed 's/_a.*//g'| sed 's/_i.*//g' | sed 's/.*_//g' | sed 's/-.*//g' | sort -u | tac | sed 1q)
			;;
		esac
		for j in $DISTRIB; do
			PACKAGE=$(find ${REPREPRO_DIR}/${j} -name "${l}_*.deb" | sort -r |sed 1q)
			case ${l} in
				ocrodjvu|balsa|gscan2pdf|pinta|mypaint|freecad*|qcad|tesseract*|aegisub|kvirc*|clementine|deadbeef|goaccess|ppastats|gimp*|llpp|scantailor*|solvespace|librecad)
				VERSION=$(echo ${PACKAGE} | sed 's/_a.*//g'| sed 's/_i.*//g' | sed 's/.*_//g'| sed 's/ppa.*//g' | rev | cut -c 3- | rev)
				;;
				*)
				VERSION=$(echo ${PACKAGE} | sed 's/_a.*//g'| sed 's/_i.*//g' | sed 's/.*_//g' | sed 's/-.*//g')
				;;
			esac
			DIR=$(echo ${PACKAGE%/*} | sed 's/.*reprepro//g' | sed 's/pool\///g')
			if [ -z	$VERSION ]
				then
					echo "                <td class=\"hrecord\">  </td>" >> $i
				else
					if [ ! -z "$(echo $VERSION | grep $UPVERSION)" ]
					then
					echo "                <td><a href=\"https://notesalexp.${NETORG}${DIR}\"> ${VERSION} </a></td>" >> $i
					else
					echo "                <td class=\"hrecord\"><a href=\"https://notesalexp.${NETORG}${DIR}\"> ${VERSION} </a></td>" >> $i
					fi
#					echo "                <td> ${VERSION} </td>" >> $i
			fi
		done
		if [ ! -z $DEB_HOMEPAGE ]
			then
			SOURCE=$(dpkg-deb -I ${DEB_HOMEPAGE}| grep Source: | sed 's/.*e: //')
			if [ -z	$SOURCE ]
				then
					SOURCE=$(dpkg-deb -I ${DEB_HOMEPAGE}| grep Package: | sed 's/.*e: //')
			fi
		fi
		DSC=$(find ${REPREPRO_DIR}/source -name "${SOURCE}_*.dsc" | sed 1q)
		case ${l} in
			balsa|gscan2pdf|pinta|mypaint|freecad*|qcad|tesseract*|aegisub|kvirc|clementine|deadbeef|goaccess|ppastats|gimp*|scantailor|llpp|solvespace|librecad)
			DSCVERSION=$(echo ${DSC} | sed 's/.*_//g'| rev | cut -c 7- | rev)
			;;
			*)
			DSCVERSION=$(echo ${DSC} | sed 's/_a.*//g'| sed 's/_i.*//g' | sed 's/.*_//g' | sed 's/-.*//g')
			;;
		esac
		DSCFILE=$(echo ${DSC} | sed 's/.*reprepro//g' | sed 's/pool\///g')
		if [ -z	$DSCVERSION ]
			then
				echo "                <td class=\"hrecord\">  </td>" >> $i
			else
				echo "                <td><a href=\"https://notesalexp.${NETORG}${DSCFILE}\"> ${DSCVERSION} </a></td>" >> $i
		fi
		unset SOURCE DEB_HOMEPAGE 
		echo "            </tr>" >> $i
		N=$((N+1))
	done
done

for i in $NET_INDEX $ORG_INDEX $NET_INDEX_RU $ORG_INDEX_RU; do
NET_ORG=$(echo $i | sed 's/_.*//g' | sed 's/.*-//g')
	if [ -z "$(echo $NET_ORG | grep net)" ]
		then
			cat $ORG_INDEX_TMP >> $i
		else
			cat $NET_INDEX_TMP >> $i
		fi
done

for i in $NET_INDEX $ORG_INDEX $NET_INDEX_RU $ORG_INDEX_RU; do
cat >> $i << EOF
    </table>
<p>
EOF
done

#echo "Mirror: <a href=\"http://notesalexp.org/\">notesalexp.org</a>" >> $NET_INDEX
#echo "Mirror: <a href=\"http://notesalexp.net/\">notesalexp.net</a>" >> $ORG_INDEX
#echo "Зеркало: <a href=\"http://notesalexp.org/\">notesalexp.org</a>" >> $NET_INDEX_RU
#echo "Зеркало: <a href=\"http://notesalexp.net/\">notesalexp.net</a>" >> $ORG_INDEX_RU

for i in $NET_INDEX $ORG_INDEX $NET_INDEX_RU $ORG_INDEX_RU; do
cat >> $i << EOF
</p>
<p>
	Launchpad:
EOF
done

for i in $NET_INDEX $ORG_INDEX $NET_INDEX_RU $ORG_INDEX_RU; do
	NETORG=$(echo $i | sed 's/_.*//g' | sed 's/.*-//g')
	for j in $PPA_UBUNTU; do
	l=$(echo "${j}" | sed 's/\(.\)/\u\1/')
echo "    <a href=\"http://launchpad.net/~alex-p/+archive/notesalexp-${j}\">${l}</a>" >> $i
	done
done

for i in $NET_INDEX $ORG_INDEX $NET_INDEX_RU $ORG_INDEX_RU; do
cat >> $i << EOF
</p>
<table align="right" >
    <tr>
        <td>
            <p>
                <a href="http://validator.w3.org/check?uri=referer"><img
                src="http://www.w3.org/Icons/valid-html401" alt="Valid HTML 4.01 Transitional" height="31" width="88"></a>
            </p>
        </td>
        <td>
            <p>
                <a href="http://jigsaw.w3.org/css-validator/check/referer">
                <img style="border:0;width:88px;height:31px"
                src="http://jigsaw.w3.org/css-validator/images/vcss"
                alt="Valid CSS!" >
                </a>
            </p>
        </td>
    </tr>
</table>
EOF
done


#for i in $NET_INDEX $ORG_INDEX; do
#cat >> $i << EOF
#<p>
	#Launchpad(daily builds):
#EOF
#done

#for i in $NET_INDEX_RU $ORG_INDEX_RU; do
#cat >> $i << EOF
#<p>
#	Launchpad(ежедневные сборки):
#EOF
#done
#
#for i in $NET_INDEX $ORG_INDEX $NET_INDEX_RU $ORG_INDEX_RU; do
#	NETORG=$(echo $i | sed 's/_.*//g' | sed 's/.*-//g')
#	for j in $PPA_UBUNTU_DAY; do
#	l=$(echo "${j}" | sed 's/\(.\)/\u\1/')
#echo "	<a href=\"https://launchpad.net/~alex-p/+archive/notesalexp-${j}-daily\">${l}</a>" >> $i
#	done
#done

for i in $NET_INDEX $ORG_INDEX; do
cat >> $i << EOF
<!--
</p>
-->
<p>
Blog:   <a href="https://notesalexp.org/html/blog/">https://notesalexp.org/html/blog/</a>
</p>
EOF
done

for i in $NET_INDEX_RU $ORG_INDEX_RU; do
cat >> $i << EOF
<!--
</p>
-->
<p>
Блог:   <a href="https://notesalexp.org/html/blog/">https://notesalexp.org/html/blog/</a>
</p>
EOF
done

for i in $NET_INDEX $ORG_INDEX $NET_INDEX_RU $ORG_INDEX_RU; do
cat >> $i << EOF
<div id="disqus_thread"></div>
<script type="text/javascript">
        /* * * CONFIGURATION VARIABLES: EDIT BEFORE PASTING INTO YOUR WEBPAGE * * */
        var disqus_shortname = 'notesalexp'; // required: replace example with your forum shortname

        /* * * DON'T EDIT BELOW THIS LINE * * */
        (function() {
            var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
            dsq.src = '//' + disqus_shortname + '.disqus.com/embed.js';
            (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
        })();
</script>
<noscript>Please enable JavaScript to view the <a href="http://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>
<p></p>
<!--
timestamp: $TIMESTAMP
-->
EOF
done

for i in $NET_INDEX $ORG_INDEX; do
cat >> $i << EOF
<table width="100%" border="0px">
    <tbody>
        <tr>
            <td align="center"><font size="2">© Alexander Pozdnyakov, 2010–2018</font></td>
        </tr>
    </tbody>
</table>
</body>
</html>
EOF
done

for i in $NET_INDEX_RU $ORG_INDEX_RU; do
cat >> $i << EOF
<table width="100%" border="0px">
    <tbody>
        <tr>
            <td align="center"><font size="2">© Александр Поздняков, 2010–2018</font></td>
        </tr>
    </tbody>
</table>
</body>
</html>
EOF
done



#mv -f $NET_INDEX ${OUT_DIR}/index-net.html
mv -f $ORG_INDEX ${OUT_DIR}/index-org.html
#mv -f $NET_INDEX_RU ${OUT_DIR}/index-net_ru.html
mv -f $ORG_INDEX_RU ${OUT_DIR}/index-org_ru.html
