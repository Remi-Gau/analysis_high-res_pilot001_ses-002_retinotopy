# Running fmriprep with datalad

Adapted from the F big workflow:

https://github.com/psychoinformatics-de/fairly-big-processing-workflow/blob/main/bootstrap_forrest_fmriprep.sh

## Requirements

- docker / singularity
- dalalad extensions: mentioned in the [requirements.txt](../requirements.txt)
  - neuroimaging
  - containers

This will install those extensions.

```bash
pip install -r code/requirements.txt
```

## Install container image as subdataset

```bash
container_name='bids-fmriprep'
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
  $container_name
```

## Freesurfer licence

```bash
path_to_FS_licence="$HOME/Dropbox/Softwares/Freesurfer/License/license.txt"
cp ${path_to_FS_licence} code/license.txt
datalad save -m "Add Freesurfer license file"
```

### Use datalad to call fmriprep

```bash
sub_id="pilot001"
task_id='retino'

datalad containers-run \
  -m "Compute ${subid}" \
  --container-name bids-fmriprep \
  --explicit \
  --output outputs/derivatives \
  --input inputs/raw/sub-$sub_id/ses-001/anat \
  --input inputs/raw/sub-$sub_id/ses-002/func/*${task_id}* \
  --input code/license.txt \
  "sh code/runfmriprep.sh $sub_id"
```

```bash
sub_id="pilot001"
task_id='retino'

datalad containers-run \
  -m "Compute ${subid}" \
  --container-name bids-fmriprep \
  --explicit \
  --output outputs/derivatives \
  --input inputs/raw/sub-$sub_id/ses-001/anat \
  --input inputs/raw/sub-$sub_id/ses-002/func/*retinotopyDriftingBar* \
  --input code/license.txt \
  /singularity inputs/raw outputs/derivatives participant \
    --participant-label $sub_id \
    -w ouputs/derivatives/wdir \
    -t retinotopyDriftingBar \
    --fs-license-file code/license.txt \
    --bids-filter-file code/fmriprep/bids_filter_file.json \
    --skip-bids-validation \
    --output-spaces \
    --ignore fieldmaps
```