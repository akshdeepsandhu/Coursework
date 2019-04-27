#Get data
treatment = webwork_1.1
control = webwork_1.1.2
#1a) testing the hypothesis that the population means are the same for before exercise and after exercise. 
t1 = t.test(treatment$Before, treatment$After, paired=TRUE)
md = -2.766667
se_1 = (4.6697569 - md)/2.200985

#1b) testing whether or not the Experimental and Control Groups were different before the exercise
treatmentBefore = treatment$Before
controlBefore = control$Control_Before
#two sample t-test
t2 = t.test(treatmentBefore, controlBefore, var.equal = TRUE)
#mean difference
mad = abs(21.55000  - 20.52727)
se = (8.216031- mad)/2.079614

#1c) compare population differences. Then if the std of larger (treatment) 
# of the groups is more than twice of the smaller group, unpooled test

diff_control = control$Control_After - control$Control_Before
control_diff_mean = mean(diff_control)
control_diff_std = sd(diff_control)


diff_treat = treatment$After - treatment$Before
treat_diff_mean = mean(diff_treat)
treat_diff_std = sd(diff_treat)

treat_diff_std/2 

# since treat_diff_std/2 > control_diff_std we have to use an unpooled t-test
t3 = t.test(diff_control,diff_treat, alternative="two.sided", var.equal=FALSE)
md_3 = (-0.3909091 - -2.7666667)
se =(4.3382116  -  2.375758)/  2.160369



