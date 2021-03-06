# Running fmriprep

- [Running fmriprep](#running-fmriprep)
  - [Requirements](#requirements)
  - [Freesurfer licence](#freesurfer-licence)
  - [Run with Docker](#run-with-docker)
    - [Notes](#notes)
  - [Run with singularity](#run-with-singularity)
  - [Running with datalad](#running-with-datalad)
    - [Install container image as subdataset](#install-container-image-as-subdataset)
    - [Use datalad to call fmriprep](#use-datalad-to-call-fmriprep)

## Requirements

- docker / singularity
- dalalad extensions: mentioned in the [requirements.txt](../requirements.txt)
  - neuroimaging
  - containers

This will install those extensions.

```bash
pip install -r code/requirements.txt
```

## Freesurfer licence

```bash
path_to_FS_licence="$HOME/Dropbox/Softwares/Freesurfer/License/license.txt"
cp ${path_to_FS_licence} code/license.txt
datalad save -m "Add Freesurfer license file"
```

## Run with Docker

from `code/fmriprep`

```bash
root_dir="$PWD/../.."
input_dir=${root_dir}/inputs/raw
output_dir=${root_dir}/outputs/derivatives
code_dir=${root_dir}/code

sub_id="pilot001"
task_id="retinotopyDriftingBar"

docker run -it --rm \
	-v $code_dir:/code \
	-v $input_dir:/data \
	-v $output_dir:/out \
  --user "$(id -u):$(id -g)" \
	nipreps/fmriprep:21.0.1 /data/ /out/fmriprep \
	participant --participant_label ${sub_id} \
	--fs-license-file /code/license.txt \
	--output-spaces T1w \
  --task-id ${task_id} \
  --work-dir /out/wdir/ \
  --bids-filter-file /code/fmriprep/bids_filter_file.json \
  --skip-bids-validation \
  --ignore fieldmaps
```

### Notes

Note using the docker argument `--user "$(id -u):$(id -g)"` did not work because
docker was not able to create the directories.

Not tried: `--work-dir /out/wdir/`

## Run with singularity

See nipreps doc: https://www.nipreps.org/apps/singularity/

Build singularity image:

```
singularity build   code/images/fmriprep-21.0.1.simg \
                    docker://nipreps/fmriprep:21.0.1
```

## Running with datalad

Adapted from the F big workflow:

https://github.com/psychoinformatics-de/fairly-big-processing-workflow/blob/main/bootstrap_forrest_fmriprep.sh

### Install container image as subdataset

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
