#! /bin/perl

print "$ARGV[0]\n";
print "$ARGV[1]\n";
print "$ARGV[2]\n";

$input_path = $ARGV[0];
$sub = $ARGV[1];
$output_path = $ARGV[2];

# /oak/stanford/groups/menon/projects/ruiyuan/test_AFNI_preproc/data/imaging/participants

#@list =`ls -d  N23_* N24_* `;

`mkdir $output_path/$sub`;

	
        chomp($sub);
	$input_path_1  = "$input_path".'/'."$sub".'/'."session_1/rest_1";
	print "$path1\n";
	chdir "$path1";
	#print `ls `;

        $output_path_1 = "$output_path".'/'.$sub; 
        chdir "$output_path_1";
         
`cp $input_path_1/rest.nii.gz $output_path_1`;         

  if ( -e 'done_rest.nii')
 {
    print ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>skipping ...............$path1\n ";
  }
  else
  {
`rm tmp*`;


############################################################################################
#      prepocessing for connectivity analysis
##############################################################################################

$nvols=`3dinfo -nt rest.nii`-1;
chomp $novls;
print "$nvols\n";
`3dTcat -prefix tmp_cut_re_rest.nii rest.nii[5..$nvols]`;
`3dvolreg -prefix reg_rest.nii -base tmp_cut_re_rest.nii[0]  -fourier -maxdisp1D max_motion.D -twopass -1Dfile motion.D tmp_cut_re_rest.nii`;
`3dTstat -mean  -prefix tmp_m_reg_rest.nii  reg_rest.nii`;
########## derivative of motion parameter  ##################################################

#`1d_tool.py -infile motion.D[0]-derivative -collapse_cols euclidean_norm -write e0.norm.1d`;
#`1d_tool.py -infile motion.D[1] -derivative -collapse_cols euclidean_norm -write e1.norm.1d`;
#`1d_tool.py -infile motion.D[2] -derivative -collapse_cols euclidean_norm -write e2.norm.1d`;
#`1d_tool.py -infile motion.D[3] -derivative -collapse_cols euclidean_norm -write e3.norm.1d`;
#`1d_tool.py -infile motion.D[4] -derivative -collapse_cols euclidean_norm -write e4.norm.1d`;
#`1d_tool.py -infile motion.D[5] -derivative -collapse_cols euclidean_norm -write e5.norm.1d`;
#`cp spm2afni_motion.txt motion.D`;
`1d_tool.py -infile motion.D -derivative -collapse_cols euclidean_norm -write e.norm.1d`;

`awk '{print \$1}' motion.D > motion_1.txt`;
`awk '{print \$2}' motion.D > motion_2.txt`;
`awk '{print \$3}' motion.D > motion_3.txt`;
`awk '{print \$4}' motion.D > motion_4.txt`;
`awk '{print \$5}' motion.D > motion_5.txt`;
`awk '{print \$6}' motion.D > motion_6.txt`;

##############  motion square ##################
## motion_1.txt; motion_.1._abs.txt

for ($i=1;$i<=6;$i++)
{
open (myfile,"<","motion_$i.txt");
chomp;

$sum=0;
$j1=0;
	while ($line=<myfile>)
	{
    	$sum=$line+$sum;
   	$j1=$j1+1;
	}

$average=$sum/$j1;
print "$average\n";
print "$j1\n";

close (myfile);
open (myfile,"<","motion_$i.txt");

	while ($line0=<myfile>) 
	{
	$out=($line0 - $average)**2;
	$out_put=sprintf( "%f","$out\n")   ;
	open(o,">>","motion_.$i._abs.txt");
	print o "$out_put\n";
	}

close o;
close (myfile);

}

###############  motion back ward ################3
# motion_fo_1.txt; motion_fo_.1._abs.txt

for ($j=1;$j<=6;$j++)
{

$insert_number=0;
open (In,"<","motion_$j.txt");
my @body=<In>;
close(In);

open(p,">>","motion_fo_$j.txt");
print p "$insert_number\n";
my $body=@body;

	for (my $ii=0; $ii<$body-1; $ii++)
	{
	print p "$body[$ii]";
	}
	close(p);

open (forwardfile,"<","motion_fo_$j.txt");
chomp;

$sum=0;
$jj=0;

	while ($line2=<forwardfile>)
	{
    	$sum=$line2+$sum;
   	$jj=$jj+1;
	}
$average1=$sum/$jj;

print "$average1\n";
print "$jj\n";

close (forwardfile);
open (forwardfile,"<","motion_fo_$j.txt");

	while ($line1=<forwardfile>) 
	{
	$out1=($line1 - $average1)**2;
	$out_put1=sprintf( "%f","$out1\n")   ;

	open(o,">>","motion_fo_.$j._abs.txt");
	print o "$out_put1\n";
	}

close o;
close (forwardfile);

}



############ regression out head motion parameter #######################

`3dDeconvolve -input reg_rest.nii -jobs 3 -polort -1 -num_stimts 25 -stim_file 1 motion_1.txt  -stim_label 1 roll  -stim_file 2 motion_2.txt  -stim_label 2 pitch -stim_file 3 motion_3.txt  -stim_label 3 yaw  -stim_file 4 motion_4.txt  -stim_label 4  xx  -stim_file 5 motion_5.txt  -stim_label 5  yy -stim_file 6 motion_6.txt  -stim_label 6  zz -stim_file 7 motion_.1._abs.txt  -stim_label 7 roll_abs -stim_file 8 motion_.2._abs.txt  -stim_label 8 pitch_abs  -stim_file 9 motion_.3._abs.txt  -stim_label 9 yaw_abs  -stim_file 10 motion_.4._abs.txt  -stim_label 10 xx_abs  -stim_file 11 motion_.5._abs.txt  -stim_label 11 yy_abs  -stim_file 12 motion_.6._abs.txt  -stim_label 12 zz_abs  -stim_file 13 motion_fo_1.txt  -stim_label 13 roll_forward -stim_file 14 motion_fo_2.txt  -stim_label 14 pitch_forward  -stim_file 15 motion_fo_3.txt  -stim_label 15 yaw_forward  -stim_file 16 motion_fo_4.txt  -stim_label 16 xx_forward  -stim_file 17 motion_fo_5.txt  -stim_label 17 yy_forward  -stim_file 18 motion_fo_6.txt  -stim_label 18 zz_forward  -stim_file 19  motion_fo_.1._abs.txt  -stim_label 19  roll_forward_abs -stim_file 20  motion_fo_.2._abs.txt  -stim_label 20  pitch_forward_abs  -stim_file 21  motion_fo_.3._abs.txt  -stim_label 21  yaw_forward_abs  -stim_file 22  motion_fo_.4._abs.txt  -stim_label 22  xx_forward_abs  -stim_file 23  motion_fo_.5._abs.txt  -stim_label 23  yy_forward_abs  -stim_file 24  motion_fo_.6._abs.txt  -stim_label 24  zz_forward_abs  -stim_file 25 e.norm.1d  -stim_label 25 derivative   -x1D nuisances  -bucket Decon -x1D_stop `;     

`3dTproject -polort 0 -input  reg_rest.nii      -ort nuisances.xmat.1D -prefix tmp_res4d_rest.nii `;
############ smoothing #########################################################
##-mask mask_rest.nii
## -stim_file 7 csf.d -stim_label 7  csf  -stim_file 8 wm.d -stim_label 8  wm
`3dDespike -prefix tmp_desipike_rest.nii  tmp_res4d_rest.nii`;

#`3dFourier -prefix filt_res4d_rest -lowpass 0.1 -highpass 0.01 -retrend desipike_rest.nii`;
#`fslmaths  filt_res4d_rest.nii -kernel gauss 2.55 -fmean -mas mask_rest.nii smooth_res4d_rest.nii`;


############ Detrend ##############################################################

`3dDetrend -prefix tmp_dt_rest.nii  -polort 1 tmp_desipike_rest.nii`;
`3dcalc -a tmp_m_reg_rest.nii -b  tmp_dt_rest.nii -expr "a+b" -prefix done_rest.nii`;

############## Normalization : linear registeration ################################################

#`flirt -in mprage_noskull.nii -ref /usr/share/fsl/data/MNI152_T1_3mm_brain.nii.gz -out MPRAGE_2_MNI3.nii -omat MPRAGE_2_MNI3.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12 -interp trilinear`;

#`3dcalc -a res4d_rest.nii[0] -expr 'a' -prefix one_rest.nii`;

#`flirt -in tmp_one_noskull_rest.nii.gz -ref mprage_noskull.nii -omat T_rest_MPRAGE.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6`;
	
#`convert_xfm -concat MPRAGE_2_MNI3.mat -omat T_MNI3.mat T_rest_MPRAGE.mat`;
	
#`flirt -in filt_res4d_rest.nii.gz -ref /usr/local/fsl/data/standard/MNI152_T1_3mm_brain.nii.gz -out filt_res4d_rest_MNI3.nii.gz -applyxfm -init T_MNI3.mat -interp trilinear`;

############# Functional Normalisationi : Non-linear registeration   ######################################

##print "co_MPRAGE_noskull.nii comes from SPM8";
#`3dcalc -prefix co_MPRAGE_mask.nii -a c1co_MPRAGE.nii -b c2co_MPRAGE.nii -c c3co_MPRAGE.nii -expr "astep((a+b+c),0.5)"`;

#`3dcalc -prefix co_MPRAGE_noskull.nii -a co_MPRAGE.nii -b co_MPRAGE_mask.nii -expr "a*b"`;

#`flirt -ref co_MPRAGE_noskull.nii  -in done_rest.nii -dof 7 -omat func2struct.mat`;
#`flirt -ref /usr/local/fsl/data/standard/MNI152_T1_3mm_brain.nii.gz -in co_MPRAGE_noskull.nii -omat affine_transf.mat `;
#`fnirt --in=co_MPRAGE_noskull.nii --aff=affine_transf.mat --cout=nonlinear_transf --config=T1_2_MNI152_2mm`;
#`applywarp --ref=/usr/local/fsl/data/standard/MNI152_T1_3mm_brain.nii.gz --in=done_rest.nii --warp=nonlinear_transf --premat=func2struct.mat --out=Warped_rest `;
#`fslmaths sfw_rest.nii.gz -nan nsfw_rest.nii.gz`;

#`rm mask_wrest.nii`;
#`3dFourier -prefix fw_rest.nii -lowpass 0.1 -highpass 0.01 -retrend wdone_rest.nii`;
#`3dAutomask -prefix mask_wrest.nii wdone_rest.nii`;
#`fslmaths  fw_rest.nii -kernel gauss 5 -fmean -mas mask_wrest.nii sfw_rest.nii`;
##`3dcalc -prefix fin_rest -a sfw_rest.nii.gz -b ../mask_EPi.nii -expr "a*b"`;

########### T1 struct Normalisation : non-linear registration ####################################

#`flirt -ref /usr/local/fsl/data/standard/MNI152_T1_3mm_brain.nii.gz -in co_MPRAGE_noskull.nii -omat ANAT_affine_transf.mat`;
#`fnirt --in=co_MPRAGE_noskull.nii --aff=ANAT_affine_transf.mat --cout=ANAT_nonlinear_transf --config=T1_2_MNI152_2mm`;
#`applywarp --ref=/usr/local/fsl/data/standard/MNI152_T1_3mm --in=c1co_MPRAGE.nii --warp=ANAT_nonlinear_transf --out=Warped_c1MPRAGE`;
#`applywarp --ref=/usr/local/fsl/data/standard/MNI152_T1_3mm_brain.nii.gz --in=c1co_MPRAGE.nii --warp=ANAT_nonlinear_transf --out=Warped_c1MPRAGE`;

##############
`rm tmp*.*`;
}
#die;

print "$output_path_1\n";


