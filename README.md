## Setup Daniel remote environment

The below instructions setup remote environment in Cloudlab. The goal is to run a scripts keep pulling and automatically run new experiments

* Create long term dataset in [Cloudlab](https://www.cloudlab.us/create-dataset.php). The dataset size can be sum(all 5 CDN traces + their annotated file).

* Update the profile in Cloudlab (select the profile, click "edit", click "update" for Repository). Instantiate experiment from https://github.com/sunnyszy/nfs-dataset/tree/daniel. Please use the default OS image (urn:publicid:IDN+clemson.cloudlab.us+image+cops-PG0:webcachesim_simulation:2). Please create 20 nfs client nodes in Clement. Please use the long term dataset url you just creted.
* Check and make sure `~/.bashrc` contains environment variables needed (PATH,WEBCACHESIM_TRACE_DIR,WEBCACHESIM_ROOT,XDG_CONFIG_HOME)
* Check and make sure /nfs is mounted on client nfs nodes
* We can going to run master python program on nfs server. Add ssh key of nfs server to nfs client nodes.
* Prevent strict host key checking which can block parallel. Append to `~/.ssh/config`:
```bash
Host *
    StrictHostKeyChecking no
```
* Upload datasets from local to nfs master server (directory /nfs). 
* Store git credential: 
```bash
git config credential.helper store
cd ${WEBCACHESIM_ROOT}
git fetch
# enter your username and password
mkdir $XDG_CONFIG_HOME
mkdir $XDG_CONFIG_HOME/git
mv ~/.git-credentials $XDG_CONFIG_HOME/git/credentials
# check and make sure $XDG_CONFIG_HOME/git/credentials has your git credential and git pull doesn't need password again
```
* Check out the code 
```bash
cd ${WEBCACHESIM_ROOT}
git fetch
git checkout daniel
git pull
```

[comment]: <> (* Create a file: ${WEBCACHESIM_ROOT}/config_daniel/authentication.yaml and ask Zhenyu for the content)
* Update job config: `cd ${WEBCACHESIM_ROOT}/config_daniel/job_dev.yaml`. Update node fields with created NFS client nodes
* Commit and push code change
* Start the github monitor code: `cd ${WEBCACHESIM_ROOT}/scripts; bash ./git_pulling.sh`. Ask Zhenyu to do a test configuration
