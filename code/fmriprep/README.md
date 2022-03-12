# Running fmriprep with datalad

Adapted from the F big workflow:

https://github.com/psychoinformatics-de/fairly-big-processing-workflow/blob/main/bootstrap_forrest_fmriprep.sh


## Install container image as subdataset

```bash
containername='bids-fmriprep'
container="https://github.com/ReproNim/containers.git"


# clone the container-dataset as a subdataset. 
datalad clone -d . "${container}" code/pipeline

# Register the container in the top-level dataset.
#-------------------------------------------------------------------------------
# FIXME: If necessary, configure your own container call in the --call-fmt
# argument. If your container does not need a custom call format, remove the
# --call-fmt flag and its options below.
# This container call-format is customized to execute an fmriprep call defined
# in a separate script, and does not need modifications if you stick to
# fmriprep.

datalad containers-add \
  --call-fmt 'singularity exec -B {{pwd}} --cleanenv {img} {cmd}' \
  -i code/pipeline/images/bids/bids-fmriprep--20.2.0.sing \
  $containername
```  

## Freesurfer licence

```bash
path_to_FS_licence="$HOME/Dropbox/Softwares/Freesurfer/License/license.txt"
cp ${path_to_FS_licence} code/license.txt
datalad save -m "Add Freesurfer license file"
```