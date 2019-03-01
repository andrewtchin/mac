#!/bin/sh
  export P4CLIENT=andrewchin_mbp
  export P4PORT=perforce-toolchain.eng.vmware.com:1666

  p4 login

  cat ~/p4.client | p4 client -i

  sudo mount -t nfs build-toolchain.eng.vmware.com:/toolchain /bldmnt/toolchain
  sudo mount -t nfs build-apps.eng.vmware.com:/apps  /bldmnt/apps

  if [ "$1" != "full" ]; then
    echo update /build/apps/bin/data
    sudo cp /bldmnt/apps/bin/data/* /build/apps/bin/data
  else
    shift
    cd /build/apps
    for dir in `ls -d *`; do
      echo updating: /build/apps/$dir
      sudo cp -v -R  /bldmnt/apps/$dir /build/apps
    done

  fi

  echo sync p4
  p4 sync "$@"
