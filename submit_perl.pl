#!/bin/perl

$job_name = 'preproc_AFNI' ;
$job_output = '/oak/stanford/groups/XX/projects/SUNID/test_AFNI_preproc/job/test.%j.out' ;
$job_error = '/oak/stanford/groups/XX/projects/SUNID/test_AFNI_preproc/job/test.%j.err' ;
$job_time = '02:00:00' ;
$input_dir = '/oak/stanford/groups/XX/rawdata/public/' ;
#$subID = '0051201'    ;
$output_dir = '/oak/stanford/groups/XX/projects/SUNID/test_AFNI_preproc/data/imaging/participants'  ;


chdir $input_dir;
@list =`ls -d * `;

#@list = ('0051201');

foreach $subID (@list)
{

 chomp($subID);
 print "submitting ...\n";
 `sbatch -J $job_name -o $job_output -e $job_error -t $job_time --qos=normal -N 1 --mem-per-cpu=4000 -p menon --wrap=" preprocfMRI_AFNI.pl  $input_dir  $subID $output_dir " `;

 print "$subID\n";
 #print $job
}

