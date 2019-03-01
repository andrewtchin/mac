#!/bin/sh
date

CHANGESET=`git rev-parse --verify HEAD`
echo Using CHANGESET=${CHANGESET}
CHANGESET_ARG="--changeset=${CHANGESET}"

BRANCH=`git branch | grep -F "*" | awk '{ print $2 }'`
if test "x$BRANCH" = "x"; then
  BRANCH=master
fi
echo Using BRANCH=${BRANCH}

REPO=`git config remote.origin.url | sed -e "s|^.*:/*||"`

NEW=0
COMP=
REMOTE_BRANCH=

#example with com substitution
#~/sandbox.sh comp=hws-thinappmgmt-lin=sb-2309048 conn

for i in "$@" ; do
  arg=${i%%=*}
  val=${i#*=}
  if test $arg = $val ; then
    val=
  fi

  case ${arg} in
    branch )
          BRANCH=${val}
          continue;;
    new ) NEW=1; continue ;;
    nochange ) CHANGESET_ARG="--no-changeset --syncto=latest"; 
          if test "x$BRANCH" != "xstaging"; then
              BRANCH=master
          fi
          continue ;;
    comp ) 
        #e.g. agave=sb-2248669
        COMP="--component-builds=${val}"; 
        continue ;;
    remote )
         REMOTE_BRANCH="topic/bretts/${val}";
         git push origin :${REMOTE_BRANCH}
         git push origin HEAD:${REMOTE_BRANCH}
         BRANCH=${REMOTE_BRANCH}
         CHANGESET_ARG="--no-changeset --syncto=latest"
         continue ;;
    old_gw ) TARGET=horizon-workspace-gateway ;;
    gw ) TARGET=hws-gateway ;;
    ap ) TARGET=hws-app-proxy ;;
    svc ) TARGET=hws-service ;;
    data ) TARGET=hws-data ;;
    old_data ) TARGET=horizon-workspace-data ;;
    d2 ) TARGET=hws-d2-rpm ;;
    hw ) TARGET=hws ;;
    cfg ) TARGET=hws-configurator ;;
    user ) TARGET=hws-configurator-user ;;
    conn ) TARGET=hws-connector ;;
    thinapp ) TARGET=hws-thinappmgmt-lin ;;
    oldthinapp ) TARGET=horizon-thinappmgmt-lin ;;
    api ) TARGET=hws-api-c ;;
    apimac ) TARGET=hws-api-c-mac ;;
    apilin ) TARGET=hws-api-c-linux ;;
    aping ) TARGET=hws-api-ng ;;
    ds ) TARGET=hws-data-server ;;
    sparrow ) TARGET=hws-sparrow ;;
    singleva ) TARGET=hws-va ;;
    sva ) TARGET=hws-va ;;
    tenant ) TARGET=hws-connector-va ;;
    les ) TARGET=hws-les-va ;;
    test ) TARGET=hws-test-va ;;
    svarpm ) TARGET=hws-va-rpm ;;
    authproxy ) TARGET=hws-authproxy ;;
    rpm ) TARGET=hws-service-rpm ;;
    agave ) TARGET=agave ;;
    xenapp ) TARGET=hws-xenapp ;;
    thinwin ) TARGET=hws-thinappmgmt-win ;;
    desktop ) TARGET=horizon-workspace-desktop ;;
    preview ) TARGET=hws-preview-server ;;
    dataclient ) TARGET=hws-data-client ;;
    common ) TARGET=hws-common-rpms ;;
    tp ) TARGET=horizon-workspace-data-thirdparty ;;
    * ) TARGET=${arg} ;;
  esac

  echo "##################### ${TARGET}"

  if test $NEW -gt 0 ; then
/build/apps/bin/gobuild sandbox queue ${TARGET} --branch=${BRANCH} --buildtype=release ${CHANGESET_ARG} --no-store-trees --accept-defaults ${COMP} --bootstrap="${TARGET}=git-eng:${REPO};%(branch);"
  else
/build/apps/bin/gobuild sandbox queue ${TARGET} --branch=${BRANCH} --buildtype=release ${CHANGESET_ARG} --no-store-trees --accept-defaults ${COMP} 
  fi
  NEW=0
done

date

