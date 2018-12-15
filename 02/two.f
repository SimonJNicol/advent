      program two
      implicit none
      integer label_len, max_lines
      parameter ( label_len = 26, max_lines = 250 )

      character (len=label_len), dimension(max_lines) :: s
      integer i

      open(10,file='scan.txt',status='old')
      do i = 1, max_lines
       read(10,*,end=100) s(i)
      end do
100   close(10)

      call compid(s)

      stop
      end program two
!
!
      subroutine compid(a)
      implicit none
      character (len=*), dimension(*) :: a
      character b*(len(a)), c*(len(a))
      integer i, j, k, m
      logical hope
!      write(6,*) sizeof(a), sizeof(a(1))  ! how to get size of an array of strings?
      do i = 1, 250
       b = a(i)
       do j = i+1, 250
        c = a(j)
        hope = .false.
        do k = 1, len(c)
!         m = scan(b,c(k:k))
         if ( b(k:k) .eq. c(k:k) ) then
         write(6,*) b
         write(6,*) c
         write(6,*) c(k:k), k
         write(6,*) 
          if ( hope ) then 
!           write(6,*) ' fail: found too many matches'
           goto 300
          else
!           write(6,*) ' hope: found one match!'
           hope = .true.
           goto 250
          endif
         endif
!         if ( hope ) then
         if ( k .eq. len(c)-1 .and. hope ) then
          write(6,*) ' match!'
          write(6,*) b
          write(6,*) c
          write(6,*) trim(b(1:k-1))//trim(b(k+1:))
          write(6,*) trim(c(1:k-1))//trim(c(k+1:))
          return
         end if
250      continue
        end do
300     continue
       end do
350    continue
      end do
400   return
      end subroutine compid
!
!
      subroutine counter(a, n2, n3)
      implicit none
      character a*(*)
      integer n2, n3
      integer i, j, occ
      character s*(1), done*(26)
      logical twos, threes
!      character alpha*26
!      data alpha / 'abcdefghijklmnopqrstuvwxyz' /
      done= ''
      twos = .true.
      threes = .true.
      do i = 1, len(a)
       occ = 0
       s = a(i:i)
       if ( scan(done,s) .gt. 0 ) goto 90
       do j = i, len(a)
        if ( s .eq. a(j:j) ) occ = occ + 1
       end do
       if ( occ .eq. 2 .and. twos ) then
        n2 = n2 + 1
        twos = .false.
       else if ( occ .eq. 3 .and. threes ) then
        n3 = n3 + 1
        threes = .false.
       endif
       done = trim(done)//s
 90    continue
      end do
      goto 120
100   write(6,*) s, i, 'non-alphabetic character'
110   goto 400
120   continue

400   return
      end subroutine counter
