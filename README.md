# AFNI-simplified-pipeline

The pipeline is based on AFNI and perl, in general performs main pre-processing steps listed below:

1. re-align
2. head-motion correction
3. time-series detrend
4. time-series dispike
5. co-registration <C>
6. normalization <C>
  
For Slurm submission system,  use submit_perl.pl to run preprocfMRI_AFNI.pl. 


