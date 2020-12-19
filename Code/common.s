#
# CMPUT 229 Assignment Solution License
# Version 1.0
#
# Copyright 2020 University of Alberta --- all rights are reserved
# Copyright 2020 Quinn Pham
#
# Unauthorized redistribution is forbidden in all circumstances. Use of this
# software without explicit authorization from the author or CMPUT 229
# Teaching Staff is prohibited.
#
# This software was produced as a solution for an assignment in the course
# CMPUT 229 - Computer Organization and Architecture I at the University of
# Alberta, Canada. This solution was produced by the teaching staff or their
# designates. This software is confidential and always remains confidential.
#
# Accessing, distributing, sharing of this software is illegal.
# Copying any portion of this software into another software
# without including this copyright notice is illegal.
#
# If any portion of this software is included in a solution submitted for
# grading at an educational institution, the submitter will be subject to
# the sanctions for plagiarism at that institution.
#
# If this software is found in any public website or public repository, the
# person finding it is kindly requested to immediately report, including
# the URL or other repository locating information, to the following email
# address:
#
#          cmput229@ualberta.ca
#
#-------------------------------
# Lab_PacketForward-Checksum Private Common File
# Author: Quinn Pham
# Date: July 27, 2020
#
# Adapted from:
# Lab- Reverse Polish Notation Calculator
# Author: Kristen Newbury
# Date: August 9 2017
#
# RISC-V Modifications 
# Author: Abdulrahman Alattas
# Date: May 2, 2019
#
# Adapted from:
# Control Flow Lab - Student Testbed
# Author: Taylor Lloyd
# Date: July 19, 2012
#
# THIS FILE IS NOT TO BE PROVIDED TO STUDENTS, it NOT EQUAL the Public Common File. 
# This file assesses the correctness of the assigned functions: "getHeaderLength", 
# "flipHalfwordBytes", and "checksum".
#
# This code loads an IP packet from the file specified by the path in the program 
# argument into memory, then produces three lines of output: . 
#
#	1. the return value of getHeaderLength(Addr[packet]) 
#	2. the return value of flipHalfwordBytes(H_1)
#	3. the return value of checksum(Addr[packet])
#
#-------------------------------


.data
packet:		.space	128
packetFileName:	.space	64
noFileStr:	.asciz 	"Couldn't open specified file.\n"

.align 2

.text 

main:
lw	a0, 0(a1)		# Put the filename pointer into a0
li	a1, 0			# Flag: Read Only
li	a7, 1024		# Service: Open File
ecall				# File descriptor gets saved in a0 unless an error happens

bltz	a0, fileError  		# Negative means open failed

readSuccess:
la	a1, packet		# write into my binary space
li	a2, 2048        	# read a file of at max 2kb
li	a7, 63          	# Read File Syscall
ecall

la	s0, packet		# s0 <- Addr[packet]

mv	a0, s0			# a0 <- Addr[packet]
jal	ra, getHeaderLength	# a0 <- getHeaderLength(Addr[packet])
li	a7, 1			# a7 <- 1
ecall				# printInt(getHeaderLength(Addr[packet])

li	a0, 0xA			# a0 <- '\n'
li	a7, 11			# a7 <- 11
ecall 				# printChar('\n')

lhu	a0, 0(s0)		# a0 <- Halfword #1
jal	ra, flipHalfwordBytes	# a0 <- flipHalfwordBytes(Halfword #1)
li	a7, 34			# a7 <- 34
ecall				# printIntHex(flipHalfwordBytes(Halfword #1))

li	a0, 0xA			# a0 <- '\n'
li	a7, 11			# a7 <- 11
ecall 				# printChar('\n')

mv	a0, s0			# a0 <- Addr[packet]
jal	ra, checksum		# a0 <- checksum(Addr[packet])
li	a7, 34			# a7 <- 34 
ecall				# PrintIntHex(checksum(Addr[packet]))

li	a0, 0xA			# a0 <- '\n'
li	a7, 11			# a7 <- 11
ecall 				# printChar('\n')

j	mainDone		# goto mainDone
	
fileError:
la	a0, noFileStr   	# print error message in the event of an error when trying to read a file                       
li	a7, 4           	# the number of a system call is specified in a7
ecall             		# Print string whose address is in a0

mainDone:
li      a7, 10          # ecall 10 exits the program with code 0
ecall

#-------------------end of common file-------------------------------------------------
