#when dividing takes consider the number of nodes requesting for the job
# totFrames={{{ total_frames }}}
# nodes={{{ nodes }}}
# (( tskSize= ($totFrames/$nodes) ))
# startFrame={{{ start_frame }}}
#--------------------------------------------------

#calculate the task start and end frames
# (( sFrame= ($PBS_ARRAYID*$tskSize)-($tskSize-1)+($startFrame-1) ))
# (( eFrame= ($PBS_ARRAYID*$tskSize)+($startFrame-1) ))


START_FRAME=1
END_FRAME=20

NODES=3

for i in `seq 1 $NODES`
do

TOTAL_FRAMES=$(( END_FRAME - START_FRAME + 1 ))
TASK_SIZE=$(( TOTAL_FRAMES / NODES ))
REMAINDER=$(( TOTAL_FRAMES % NODES ))

OFFSET=$(( $i * TASK_SIZE ))
#echo "offset: $OFFSET"

TASK_START_FRAME=$(( OFFSET - TASK_SIZE + START_FRAME ))
TASK_END_FRAME=$(( OFFSET ))



echo "Node $i: $TASK_START_FRAME - $TASK_END_FRAME"

done

echo $REMAINDER