#+++++
# Quicksort.asm
# Sorting In Assmebly
# Bjorn Melin
# 4/22/19
#
# This program implements quicksort on an array of integers.
# Quicksort sorts elements of an array in place by choosing a value
# in the array as a 'pivot' value, moving values either to the left
# or to the right of the array depending on whether the values are
# less than or greater than the pivot value, respectively, and placing
# the pivot value in the space in between these two sections of the
# array.  It then recursively calls quicksort on each of the two sections.
#-----

#+++++
# Data Segment
#-----
.data
    # creates 3 arrays to be sorted of lengths 7, 8, and 9 respectively
    array1:         .word   1, 4, 54, 104, 32, 28, 12
    array2:         .word   2, 45, 15, 37, 201, 19, 46, 276
    array3:         .word   254, 781, 43, 12, 16, 107, 98, 234, 400

#+++++
# Program Segment
#-----
.text


#+++++
# Main Function
#-----
main:
    # main pushes the $ra onto the stack since main is also a function
    addi    $sp, $sp, -4        # adjusts the stack pointer for 1 item
    sw      $ra, 0($sp)


    ###### testing quicksort on array1 ######
    la      $a0, array1         # load the starting address of array1 into $a0
    li      $a1, 0              # load 0 into $a1 to be used as the start index
    li      $a2, 6              # load 6 into $a2 to be used as the end index
    jal     quicksort           # jump and link to the quicksort function


    ###### testing quicksort on array2 ######
    la      $a0, array2         # load the starting address of array2 into $a0
    li      $a1, 0              # load 0 into $a1 to be used as the start index
    li      $a2, 7              # load 7 into $a2 to be used as the end index
    jal     quicksort           # jump and link to the quicksort function


    ###### testing quicksort on array3 ######
    la      $a0, array3         # load the starting address of array3 into $a0
    li      $a1, 0              # load 0 into $a1 to be used as the start index
    li      $a2, 8              # load 8 into $a2 to be used as the end index
    jal     quicksort           # jump and link to the quicksort function


    # Restore $ra from the stack
    lw      $ra, 0($sp)
    addi    $sp, $sp, 4         # adjusts stack pointer to pop one item
    jr      $ra


#+++++
# Quicksort Function
#
# void quicksort( int[] array, int p, int r) {
#   if( p < r) {
#       int q = partition( array, p, r);
#       quicksort( array, p, q - 1);
#       quicksort( array, q + 1, r);
#       }
# }
# 3 local variables (int[] array ($s0), int p ($s1), and int r ($s2))
#-----
quicksort:
    # push the $ra and $s registers onto the stack
    addi    $sp, $sp, -20       # adjusts the stack pointer for 4 items
    sw      $ra, 0($sp)
    sw      $s0, 4($sp)         # $s0 used to store the base address of the array
    sw      $s1, 8($sp)         # $s1 used to store p (low index)
    sw      $s2, 12($sp)        # $s2 used to store r (high index)
    sw      $s3, 16($sp)        # $s3 used to store the return value of partition

    move    $s0, $a0            # stores the base array address into $s0
    move    $s1, $a1            # 0 = p (low), ($s1 = 0)
    move    $s2, $a2            # arraylength - 1 = r (high), ($s1 = arraylength - 1)


loopbegin:
    slt     $t0, $s1, $s2       # if (low < high), then $t0 = 1
    # if (low >= high) then branch to restoreAndReturn
    beq     $t0, $zero, restoreAndReturn
    jal     partition           # jump and link to partition function

    # sort the lower half of array recursively
    # q = partition(array, p, r)
    move    $s3, $v0            # moves the return value of partition into $s3

    # quicksort(array, p, q - 1)
    addi    $a1, $s1, 0         # low = p (low), ($a1 = start index in the array)
    addi    $a2, $s3, -1        # r (high) = partition value - 1, ($a2 = partition - 1)
    # jump and link to quicksort function to sort the lower half of the array
    jal     quicksort

    # quicksort(array, q + 1, r);
    addi    $a1, $s3, 1         # low = partition value + 1, ($a1 = partition + 1)
    addi    $a2, $s2, 0         # high = r (high), ($a2 = last index in the array)
    # jump and link to quicksort function to sort the upper half of the array
    jal     quicksort


restoreAndReturn:
    # put things back into registers from the stack
    lw      $ra, 0($sp)
    lw      $s0, 4($sp)
    lw      $s1, 8($sp)
    lw      $s2, 12($sp)
    lw      $s3, 16($sp)
    addi    $sp, $sp, 20        # pop the stack (restore the stack pointer)
    jr      $ra                 # jump back to the function caller in main


#+++++
# Partition Function
#
# int partition( int[] array, int p, int r) {
#   int pivot = array[r];
#   int i = p - 1;
#   for( int j = p, j < r; j++) {
#       if( array[ j] <= pivot) {
#           i = i + 1;
#           swap( array, i, j);
#       }
#   }
#   swap( array, i + 1, r);
#   return( i + 1);
# }
# 3 local variables (int[] array ($s0), int p ($s1), and int r ($s2))
#-----
partition:
    # push the $ra and $s registers onto the stack
    addi    $sp, $sp, -16       # adjusts the stack pointer for 4 items
    sw      $ra, 0($sp)
    sw      $s0, 4($sp)         # $s0 used to store the base address of the array
    sw      $s1, 8($sp)         # $s1 used to store p (low index)
    sw      $s2, 12($sp)        # $s2 used to store r (high index)

    move    $s0, $a0            # $s0 stores the base address of the array
    move    $s1, $a1            # $s1 stores p (low)
    move    $s2, $a2            # $s2 stores r (high)

    sll     $t1, $s2, 2         # $t1 = 4 * high
    add     $t1, $s0, $t1       # $t1 = arr + (4 * high)
    lw      $t2, 0($t1)         # int pivot = array[r]  ($t2 = pivot)

    addi    $t3, $s1, -1        # $t3 = low - 1 (i)
    move    $t4, $s1            # $t4 = j, (int j = p)
    addi    $t5, $s2, 0         # $t5 = high


startfor:
    slt     $t6, $t4, $t5       # if (j (low) > high) then $t6 = 1 else $t6 = 0
    beq     $t6, $zero, endfor

    sll     $t1, $t4, 2         # $t1 = 4 * j
    add     $t1, $t1, $s0       # $t1 = arr + (4*j)
    lw      $t7, 0($t1)         # $t7 = arr[j]

    slt     $t8, $t2, $t7       # if (pivot < arr[j]) then $t8 = 1 else $t8 = 0
    bne     $t8, $zero, endif
    addi    $t3, $t3, 1         # $t3 = i + 1

    move    $a1, $t3            # $a1 = i
    move    $a2, $t4            # $a2 = j
    jal     swap                # swap( array, i, j)


endif:
    addi    $t4, $t4, 1         # j++
    j       startfor            # jump back to the top of the loop


endfor:
    addi    $a1, $t3, 1         # $a1 = i + 1
    move    $a2, $s2            # $a2 = high
    add     $v0, $zero, $a1     # put (i + 1) into the return register
    jal     swap                # swap(arr, i + 1, high)

    # put things back into registers from the stack
    lw      $ra, 0($sp)
    lw      $s0, 4($sp)
    lw      $s1, 8($sp)
    lw      $s2, 12($sp)
    addi    $sp, $sp, 16            # pop the stack (restore the stack pointer)
    jr      $ra                     # jump back to the function caller in main


#+++++
# Swap Function
# Used the same swap function as given on moodle.
#
# void swap( int[] array, int i, int j) {
#   int temp = array[ i];
#   array[ i] = array[ j];
#   array[ j] = temp;
# }
# 3 local variables (int[] array ($s0), int i ($s1), and int j ($s2))
#-----
swap:
    # push the $ra
    # Store the return address and s registers on the stack
    addi    $sp, $sp, -28   # adjusts the stack pointer for 4 items
    sw      $ra, 0 ($sp)
    sw      $s0, 4 ($sp)
    sw      $s1, 8 ($sp)
    sw      $s2, 12($sp)
    sw      $s3, 16($sp)
    sw      $s4, 20($sp)
    sw      $s5, 24($sp)

    # Done with protecting registers. Now for the real work:
    sll   $s0, $a1, 2           # from * 4 into $s0
    sll   $s1, $a2, 2           # to * 4 into $s1
    add   $s2, $a0, $s0         # Address of array[from] into $s2
    add   $s3, $a0, $s1         # Address of array[ to] int9 $s3
    lw    $s4, 0($s2)           # Value of array[from] into $s4
    lw    $s5, 0($s3)           # Value of array[to] into $s5
    sw    $s4, 0($s3)           # Value from $s4 into array[to]
    sw    $s5, 0($s2)           # Value from $s5 into array[from]

    # Done with the work. No return value.
    # Restore the $ra and $s registers from the stack
    lw    $ra, 0 ($sp)
    lw    $s0, 4 ($sp)
    lw    $s1, 8 ($sp)
    lw    $s2, 12($sp)
    lw    $s3, 16($sp)
    lw    $s4, 20($sp)
    lw    $s5, 24($sp)
    addi  $sp, $sp, 28          # Pop the stack pointer
    jr      $ra                 # jump back to the function caller in main


