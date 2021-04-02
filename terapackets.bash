#!/usr/bin/env bash

DIR="/opt/threatReplayer"
TESTDIR=1
ALLsingle="a"
LOOPS=3

cd ${DIR}

#Interview part
echo
echo
echo "vNGFW Vendor:"
echo "(a) Barracuda"
echo "(b) Checkpoint"
echo "(c) Cisco"
echo "(d) Forcepoint"
echo "(e) Fortinet"
echo "(f) PaloAlto"
echo "(g) Juniper"
echo "(h) Sangfor"
echo "(i) Sonicwall"
echo "(j) Sophos"
echo "(k) Versa"
echo "(l) Watchguard"
read -p 'a-l: ' VENDOR_sel

if [[ ${VENDOR_sel} == "a" ]]; then
	VENDOR="Barracuda"
fi

if [[ ${VENDOR_sel} == "b" ]]; then
    VENDOR="Checkpoint"
fi

if [[ ${VENDOR_sel} == "c" ]]; then
    VENDOR="Cisco"
fi

if [[ ${VENDOR_sel} == "d" ]]; then
    VENDOR="Forcepoint"
fi

if [[ ${VENDOR_sel} == "e" ]]; then
    VENDOR="Fortinet"
fi

if [[ ${VENDOR_sel} == "f" ]]; then
    VENDOR="PaloAlto"
fi

if [[ ${VENDOR_sel} == "g" ]]; then
    VENDOR="Juniper"
fi

if [[ ${VENDOR_sel} == "h" ]]; then
    VENDOR="Sangfor"
fi

if [[ ${VENDOR_sel} == "i" ]]; then
    VENDOR="Sonicwall"
fi

if [[ ${VENDOR_sel} == "j" ]]; then
    VENDOR="Sophos"
fi

if [[ ${VENDOR_sel} == "k" ]]; then
    VENDOR="Versa"
fi

if [[ ${VENDOR_sel} == "l" ]]; then
    VENDOR="Watchguard"
fi

HOMEDIR=/home/results/${VENDOR}

if [ -d "${HOMEDIR}" ]; then
	rm -rf ${HOMEDIR} 
	mkdir -p ${HOMEDIR}
else
	mkdir -p ${HOMEDIR}
fi

echo
echo
echo "Results will be in ${HOMEDIR}"
echo
echo
echo "What lane?"
read -p 'Lane Number: ' LANE_NUM
echo
echo
IP0="10.${LANE_NUM}"

echo "Would you like to run - "
echo "(a)  All strikes, all years"
echo "(b)  Single strike year"
read -p 'a-b: [a] ' ALLsingle_sel

if [[ ${ALLsingle_sel} == "b" ]]; then
	ALLsingle="b"
fi

if [[ ${ALLsingle} == "a" ]]; then
	echo
	echo	
	echo "How many test loops?"
	read -p 'loops: [3] ' LOOPS_sel
	if [[ ${LOOPS_sel} != ${LOOPS} ]]; then
		let "LOOPS=LOOPS_sel"
	fi
	while [[ ${TESTDIR} -le ${LOOPS} ]]; do
		echo
		echo
		cd ${DIR}
		echo " >>  Starting Loop ${TESTDIR} of ${LOOPS}  << "
		echo
		date
		echo
		echo "All years"
		echo "${DIR}/runAll /PCAPS/ ${IP0}.3.11-${IP0}.3.136 ${IP0}.1.11-${IP0}.1.136 --worker 2 --shuffle --wait"
		ulimit -n 50000
		perl ${DIR}/runAll /PCAPS/ ${IP0}.3.11-${IP0}.3.136 ${IP0}.1.11-${IP0}.1.136 --worker 2 --shuffle --wait
		mkdir "${HOMEDIR}/${TESTDIR}"
		mv ${DIR}/result_0_1.txt ${HOMEDIR}/${TESTDIR}/${VENDOR}_loop_${TESTDIR}_results.csv
		mv ${DIR}/debugpcap0.pcap ${HOMEDIR}/${TESTDIR}/${VENDOR}_loop_${TESTDIR}_port0.pcap
		mv ${DIR}/debugpcap1.pcap ${HOMEDIR}/${TESTDIR}/${VENDOR}_loop_${TESTDIR}_port1.pcap
		mv ${DIR}/completedPcaps.txt ${HOMEDIR}/${TESTDIR}/${VENDOR}_loop_${TESTDIR}_missed.txt
		tar -czvf ${DIR}/${VENDOR}_loop_${TESTDIR}_results.tar.gz ${HOMEDIR}/${TESTDIR}
		mv ${DIR}/${VENDOR}_loop_${TESTDIR}_results.tar.gz ${HOMEDIR}/${TESTDIR}
		echo "File List:"
		ls "${HOMEDIR}/${TESTDIR}"
		echo
		date
		echo
		echo " <<  Loop ${TESTDIR} of ${LOOPS} Complete  >> "
		let "TESTDIR=TESTDIR+1"
	#	echo ${TESTDIR}
		echo
		echo
		echo
	# Timer
		echo "90 second pause between runs....  "
		echo
	#	min=0
		seconds=90; date1=$((`date +%s` + ${seconds})); 
		while [ "${date1}" -ge `date +%s` ]; do 
			echo -ne "$(date -u --date @$((${date1} - `date +%s` )) +%H:%M:%S)\r"
		done;
	done
		echo
		echo
		echo	
		echo
		echo "${LOOPS} Loops are complete"
		echo
		echo "Logs are in ${HOMEDIR}"
		echo
		echo	
		echo;
fi

# Single strike year
if [[ ${ALLsingle} == "b" ]]; then
	echo
	echo	
	echo "What year? "
	read -p 'Year: ' YEAR
	echo 
	echo
	echo " >>  Starting Strike Year ${YEAR}  << "
	echo
	date
	echo
	echo "${YEAR}"
	echo "${DIR}/runAll /PCAPS/ ${IP0}.3.11-${IP0}.3.136 ${IP0}.1.11-${IP0}.1.136 --worker 2 --shuffle --wait"
	ulimit -n 50000
	perl ${DIR}/runAll /PCAPS/${YEAR} ${IP0}.3.11-${IP0}.3.136 ${IP0}.1.11-${IP0}.1.136 --worker 2 --shuffle --wait
	mkdir "${HOMEDIR}/${YEAR}"
	mv ${DIR}/result_0_1.txt ${HOMEDIR}/${YEAR}/${VENDOR}_${YEAR}_results.csv
	mv ${DIR}/debugpcap0.pcap ${HOMEDIR}/${YEAR}/${VENDOR}_${YEAR}_port0.pcap
	mv ${DIR}/debugpcap1.pcap ${HOMEDIR}/${YEAR}/${VENDOR}_${YEAR}_port1.pcap
	if [ -f "${DIR}/completedPcaps.txt" ]; then
		mv ${DIR}/completedPcaps.txt ${HOMEDIR}/${YEAR}/${VENDOR}_${YEAR}_Missed.txt
	fi
	tar -czvf ${DIR}/${VENDOR}_${YEAR}_Results.tar.gz ${HOMEDIR}/${YEAR}
	mv ${DIR}/${VENDOR}_${YEAR}_Results.tar.gz ${HOMEDIR}/${YEAR}
	echo "Files List:"
	ls "${HOMEDIR}/${YEAR}"
	echo
	date
	echo
	echo " <<  Completed Strike Year ${YEAR}  >> "
	echo
	echo
	echo "Results are located in ${HOMEDIR}/${YEAR}"
	echo
	echo
	echo
fi
