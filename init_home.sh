#!/bin/bash

USERNAME=$1
PROJECT_NAME=$(/bin/ls /proj)
NFS_SHARED_HOME_DIR=/proj/${PROJECT_NAME}/workspaces


if [ $(hostname --short) == "nfs" ]
then
    usermod --move-home --home $NFS_SHARED_HOME_DIR/${USERNAME} ${USERNAME}
    echo "export PATH=\$PATH:${NFS_SHARED_HOME_DIR}/${USERNAME}/webcachesim/build/bin" >> $HOME/.bashrc
    echo 'WEBCACHESIM_TRACE_DIR=/nfs' >> $HOME/.bashrc
    echo "export WEBCACHESIM_ROOT=${NFS_SHARED_HOME_DIR}/${USERNAME}/webcachesim" >> $HOME/.bashrc
    echo "export XDG_CONFIG_HOME=${NFS_SHARED_HOME_DIR}/${USERNAME}/XDG_CONFIG" >> $HOME/.bashrc
    printf "Host * \nStrictHostKeyChecking no" > $HOME/.ssh/config
else
    usermod --home $NFS_SHARED_HOME_DIR/${USERNAME} ${USERNAME}
fi

# Setup password-less ssh between nodes
if [ $(hostname --short) == "nfs" ]
then
  ssh_dir=$NFS_SHARED_HOME_DIR/$USERNAME/.ssh
  /usr/bin/geni-get key > $ssh_dir/id_rsa
  chmod 600 $ssh_dir/id_rsa
  chown $USERNAME: $ssh_dir/id_rsa
  ssh-keygen -y -f $ssh_dir/id_rsa > $ssh_dir/id_rsa.pub
  cat $ssh_dir/id_rsa.pub >> $ssh_dir/authorized_keys
  chmod 644 $ssh_dir/authorized_keys
fi

