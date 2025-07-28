       program ETPA

       IMPLICIT NONE
       DOUBLE COMPLEX :: X(9),Stemp(3),Z(9,9),spa
       DOUBLE COMPLEX :: S
       COMPLEX :: imag,epsilons(3),epsiloni(3),Sepsilon(3),Mepsilon(3)
       DOUBLE PRECISION :: MUeg(3),MUfe(3),M(3,3),aveomegai,omegap,dE
       DOUBLE PRECISION :: aveomegas
       DOUBLE PRECISION, ALLOCATABLE :: Sgrid(:),Igrid(:),Rgrid_deg(:)
       DOUBLE PRECISION, ALLOCATABLE :: EIG(:),MU(:,:,:),OSC(:)
       DOUBLE PRECISION, ALLOCATABLE :: Rgrid(:,:),Agrid(:,:),energy(:)
       DOUBLE PRECISION, ALLOCATABLE :: spectrum(:),spa_E(:)
       REAL :: iGAMMA,Tent,d,e,spamin,spamax,iGAMMA_spa
       REAL :: a,nm,mx,my,mz,m2,f,omegaimin,omegaimax,omegaidel
       REAL :: omegasmin,omegasmax,omegasdel,MUkron(9)
       REAL, ALLOCATABLE :: omegai(:),omegas(:),aGAMMA(:)
       INTEGER :: V(9),nEIG,ng,nf,ne,i,j,k,io,root,NROOTS,IROOT
       INTEGER :: NROOT,sEIG,step_s,step_i,l,h,dd,step_spa
       CHARACTER(len=50) :: ORCAout,str4,mlab,drg
       CHARACTER(len=32) :: str1,b,out_format
       CHARACTER(len=67) :: str2
       CHARACTER(len=72) :: str3
       CHARACTER(len=1) :: c
       CHARACTER(len=3) :: deg
       CHARACTER(len=32), PARAMETER :: sroot="Number of roots to be" //
     2                                      " determined"
       CHARACTER(len=67), PARAMETER :: sspect="         ABSORPTION" //
     2         " SPECTRUM VIA TRANSITION ELECTRIC DIPOLE MOMENTS"
       CHARACTER(len=72), PARAMETER :: stpect="    TRANSIENT" //
     2 " ABSORPTION SPECTRUM VIA TRANSITION ELECTRIC DIPOLE MOMENTS"
       



!!!!!! Read in Dipole Moments and Eigenenergies from Orca .out file !!!!!
!!!!!! Lines related to File 52 are optional                        !!!!!
                                                                        ! 
       call get_command_argument(1,ORCAout)                             ! Gets name of Orca .out file from command line argument
       open(24,file=ORCAout,status='old',action='read',iostat=io)       ! Opens Orca .out file
         if (io /= 0) then; stop "Could not open ORCA .out file"; endif ! Ends program if there is no Orca .out file
       do i = 1, 1000000                                                !
         read(24,'(A32,A50)',iostat=io) str1,str4                       ! Reads Orca .out file line by line
         if (io /= 0) then; exit; endif                                 ! Ends do loop at end of file
         if (str1 == sroot) then                                        ! Compares line to string we are interested in
           read(str4,*) b,NROOTS                                        ! Number of Roots in calculation
           exit                                                         ! Ends do loop when we get the number of roots
           close(24)                                                    ! Closes Orca .out file
         endif                                                          !
       enddo                                                            !
       allocate(EIG(NROOTS+1))                                          ! Set size of EIG array
       allocate(MU(NROOTS+1,NROOTS+1,3))                                ! Set size of MU array
       allocate(OSC(NROOTS))                                            ! Set size of OSC array
       allocate(energy(NROOTS))                                         ! Set size of energy array
       EIG(1)=0                                                         ! Set value for Ground State Energy
       i=scan(trim(ORCAout),".",BACK=.true.)                            ! Not actually needed for calculation.  Setup for optional output file.
       mlab=ORCAout(1:i)//"mlab"                                        ! Not actually needed for calculation.  Setup for optional output file.
       open(24,file=ORCAout,status='old',action='read')                 ! Opens Orca .out file
       open(52,file=mlab,status='replace')                              ! Open Optional output file
       IROOT=0                                                          ! Conditional do loop counter
       NROOT=NROOTS                                                     ! Another loop counter
       do i = 1, 1000000                                                !
         read(24,'(A67)',iostat=io) str2                                ! Reads Orca .out file line by line
         if (io /= 0) then; exit; endif                                 ! Ends do loop at end of file
         if (str2 == sspect) then                                       ! Compares line to string we are interested in
           do j = 1, 4                                                  !
             read(24,*)                                                 ! Skip 4 lines in Orca .out file
           enddo                                                        !
           do j = 1, NROOT                                              ! Loop over number of excitations
             read(24,*) root,a,nm,f,m2,mx,my,mz                         ! Read in values from absorption spectra data
             write(52,200) IROOT,root,a/219474.63136314,                !
     2                   a/8065.543937,nm,f,m2,mx,my,mz                 ! Make Text file with format: Initial_State Final_State Energy_Eh Energy_eV Wavelength_nm OS_str D**2_au Dx_au Dy_au Dz_au
             EIG(j+1)=a/8065.543937                                     ! Assign data to EIG variable
             MU(IROOT+1,root+1,1)=mx                                    ! Assign data to MU variable
             MU(root+1,IROOT+1,1)=mx                                    ! Assign data to MU variable
             MU(IROOT+1,root+1,2)=my                                    ! Assign data to MU variable
             MU(root+1,IROOT+1,2)=my                                    ! Assign data to MU variable
             MU(IROOT+1,root+1,3)=mz                                    ! Assign data to MU variable
             MU(root+1,IROOT+1,3)=mz                                    ! Assign data to MU variable
             OSC(j)=f                                                   ! Assign data to OSC variable
             energy(j)=a/8065.543937                                    ! Assign data to energy variable
           enddo                                                        !
           IROOT=IROOT+1                                                ! Increase Loop Counter
           NROOT=NROOT-1                                                ! Decrease Loop Counter
           exit                                                         !
         endif                                                          !
       enddo                                                            !
       close(24)                                                        ! Closes Orca .out file
200    FORMAT(I5,I5,F20.15,F20.15,X,F7.1,F13.9,F10.5,F10.5,F10.5,F10.5) ! Formatted output for .mlab file
       open(24,file=ORCAout,status='old',action='read')                 ! Opens Orca .out file
       do i=1, 1000000                                                  !
         read(24,'(A72)',iostat=io) str3                                ! Reads Orca .out file line by line
         if (io /= 0) then; exit; endif                                 ! Ends do loop at end of file
         if (str3 == stpect) then                                       ! Compares line to string we are interested in
           do j = 1, 4                                                  !
             read(24,*)                                                 ! Skip 4 lines in Orca .out file
           enddo                                                        !
           do j=1, NROOT                                                ! Loop over number of excitations
             read(24,*) root,a,nm,f,m2,mx,my,mz                         ! Read in values from transient absorption spectra data
             MU(IROOT+1,root+1,1)=mx                                    ! Assign data to MU variable
             MU(root+1,IROOT+1,1)=mx                                    ! Assign data to MU variable
             MU(IROOT+1,root+1,2)=my                                    ! Assign data to MU variable
             MU(root+1,IROOT+1,2)=my                                    ! Assign data to MU variable
             MU(IROOT+1,root+1,3)=mz                                    ! Assign data to MU variable
             MU(root+1,IROOT+1,3)=mz                                    ! Assign data to MU variable
             write(52,200) IROOT,root,45.563352529132/nm,               !
     2                   1239.841984/nm,nm,f,m2,mx,my,mz                ! Make Text file with format: Initial_State Final_State Energy_eV Wavelength_nm OS_str D**2_au Dx_au Dy_au Dz_au
           enddo                                                        !
         IROOT=IROOT+1                                                  ! Increase Loop Counter
         NROOT=NROOT-1                                                  ! Decrease Loop Counter
         endif                                                          !
       enddo                                                            !
       close(24)                                                        ! Closes Orca .out file
       close(52)                                                        ! Closes Optional .mlab output file
                                                                        !
!!!!!! END Read in Dipole Moments and Eigenenergies from Orca .out file !

!!!!!! Read in Variables from Self Made input file !!!!!!!!!!!!!!
                                                                !
       i=command_argument_count()                               ! Checking how many arguements were included in the command
       if (i==2) then                                           !
         call get_command_argument(2, drg)                      ! Using 2nd arguement as name of input file
       else                                                     !
         drg="ETPA_par"                                         ! Using default name of input file
       endif                                                    !
       open(69,file=drg,status='old',action='read',iostat=io)   ! Open input file
       if (io /= 0) then                                        ! Giving default values for variables in input file 
         omegaimin=1.5307                                       !
         omegaimax=1.5307                                       !
         omegaidel=0                                            !
         omegasmin=1.5307                                       !
         omegasmax=1.5307                                       !
         omegasdel=0                                            !
         epsiloni(1)=(1,0)                                      !
         epsiloni(2)=(0,0)                                      !
         epsiloni(3)=(0,0)                                      !
         epsilons(1)=(1,0)                                      !
         epsilons(2)=(0,0)                                      !
         epsilons(3)=(0,0)                                      !
         Tent=1E-13                                             !
         iGAMMA=0.1                                             !
         iGAMMA_spa=0.1                                         !
         spamin=0                                               !
         spamax=10                                              !
         step_spa=10000                                         !
       endif                                                    !
       read(69,*,iostat=io) omegaimin,omegaimax,omegaidel       ! Reading in values for idler frequency
       if (io /= 0) then                                        ! Giving default values for idler frequency
         omegaimin=1.5307                                       !
         omegaimax=1.5307                                       !
         omegaidel=0                                            !
       endif                                                    !
       read(69,*,iostat=io) omegasmin,omegasmax,omegasdel       ! Reading in values for signal frequency
       if (io /= 0) then                                        ! Giving default values for signal frequency
         omegasmin=1.5307                                       !
         omegasmax=1.5307                                       !
         omegasdel=0                                            !
       endif                                                    !
       read(69,*,iostat=io) Tent                                ! Reading in value for entanglement time
       if (io /= 0) then                                        ! Giving default value for entanglement time
         Tent=1E-13                                             !
       endif                                                    !
       read(69,*,iostat=io) iGAMMA,iGAMMA_spa                   ! Reading in value for broadening parameters
       if (io /= 0) then                                        ! Giving default value for broadening parameters
         iGAMMA=0.1                                             !
         iGAMMA_spa=0.1                                         !
       endif                                                    !
       read(69,*,iostat=io) spamin,spamax,step_spa              ! Reading in values for SPA calculation variables
       if (io/=0) then                                          ! Giving default value for SPA calculation variables
         spamin=0                                               !
         spamax=10                                              !
         step_spa=10000                                         !
       endif                                                    !
       read(69,'(A50)',iostat=io) str4                          ! Reading in value for idler polarization
       if (io /= 0) then                                        ! Giving default value for idler polarization
         epsiloni(1)=(1,0)                                      !
         epsiloni(2)=(0,0)                                      !
         epsiloni(3)=(0,0)                                      !
       endif                                                    !
       read(adjustl(str4),'(A1)') c                             !
       if (c=="(") then                                         ! Allows for setting idler polarization as a complex number
         read(str4,*) epsiloni(1),epsiloni(2),epsiloni(3)       !
       else                                                     !
         read(str4,*) a,d,e                                     !
         epsiloni(1)=cmplx(a)                                   !
         epsiloni(2)=cmplx(d)                                   !
         epsiloni(3)=cmplx(e)                                   !
       endif                                                    !
       read(69,'(A50)',iostat=io) str4                          ! Reading in value for signal polarization
       if (io /= 0) then                                        ! Giving default value for signal polarization
         epsilons(1)=(1,0)                                      !
         epsilons(2)=(0,0)                                      !
         epsilons(3)=(0,0)                                      !
       endif                                                    !
       read(adjustl(str4),'(A1)') c                             ! Allows for setting signal polarization as a complex number
       if (c=="(") then                                         !
         read(str4,*) epsilons(1),epsilons(2),epsilons(3)       !
       else                                                     !
         read(str4,*) a,d,e                                     !
         epsilons(1)=cmplx(a)                                   !
         epsilons(2)=cmplx(d)                                   !
         epsilons(3)=cmplx(e)                                   !
       endif                                                    !
       close(69)                                                !
                                                                !
!!!!!! END Read in Variables from Self Made input file  !!!!!!!!!

!!!!!! Single Photon Absorption Calculation !!!!!!!!!!!!!!!!!!!!!
                                                                !
       imag=(0,1)                                               ! Imaginary Number
       allocate(spa_E(step_spa))                                ! Set size of spa_E array
       allocate(spectrum(step_spa))                             ! Set size of spectrum array
                                                                !
       dE=(spamax-spamin)/step_spa                              ! Determine size of \DeltaE
       do i=1,step_spa                                          ! Loop over all omegas
          spa_E(i)=spamin+(dE*i)                                ! Determine value of omega at every step
       enddo                                                    !
       do j=1,step_spa                                          ! Loop over all omegas
         spa=0                                                  !
         do i=1,size(energy)                                    ! Loop over all excitations
           spa=spa+(OSC(i)/((energy(i)**2)-((spa_E(j)+          ! Calculation absorption at omega
     2         (imag*iGAMMA_spa))**2)))                         !
         enddo                                                  !
         spectrum(j)=aimag(spa)                                 ! Save absorption spectra
       enddo                                                    !
                                                                !
       open(88,file="spectrum_spa",action="write")              ! Open SPA output file
       do i=1,step_spa                                          !
         write(88,"(2F20.16)") spa_E(i),spectrum(i)             ! Write SPA data to output file
       enddo                                                    !
       close(88)                                                ! Close SPA output file
                                                                !
       deallocate(spa_E)                                        ! 
       deallocate(spectrum)                                     !
       deallocate(OSC)                                          !
       deallocate(energy)                                       !
                                                                !
!!!!!! END Single Photon Absorption Calculation !!!!!!!!!!!!!!!!!

!!!!!! Initial Variable Set Up For ETPA Calculation !!!!!!!!!!!!!!!!!!!!!
                                                                        ! Set up number of Steps for the signal and idler energy range
       if (omegasmax==omegasmin) then                                   ! Number of steps if max and min signal energy are the same
         step_s=0                                                       ! 
       elseif (omegasmin>omegasmax) then                                ! Number of steps if min signal energy is larger than max signal energy
         write(*,*) "!!!!! WARNING !!!!!  You have specified a larger"//! Warning Message
     2              " value for omega_s_min than omega_s_max."//        !
     3              " Calculation will be performed only at omega_s_min"!
         step_s=0                                                       !
       elseif (omegasdel==0 .and. omegasmax/=omegasmin) then            ! Number of steps if max and min signal energy are different and no delta E is specified
         write(*,*) "!!!!! WARNING !!!!!  You have specified a range"// ! Warning Message
     2              " for omega_s but not a step size.  A default"//    !
     3              " step size of 0.01 eV will be used"                !
         step_s=ceiling((omegasmax-omegasmin)/0.01)                     !
       else                                                             !
         step_s=ceiling((omegasmax-omegasmin)/omegasdel)                ! Number of steps if max and min signal energy are different and delta E is specified
       endif                                                            !
       if (omegaimax==omegaimin) then                                   ! Number of steps if max and min idler energy are the same
         step_i=0                                                       !
       elseif (omegaimin>omegaimax) then                                ! Number of steps if min idler energy is larger than max idler energy
         write(*,*) "!!!!! WARNING !!!!!  You have specified a larger"//! Warning Message
     2              " value for omega_i_min than omega_i_max."//        !
     3              " Calculation will be performed only at omega_i_min"!
         step_i=0                                                       !
       elseif (omegaidel==0 .and. omegaimax/=omegaimin) then            ! Number of steps if max and min idler energy are different and no delta E is specified
         write(*,*) "!!!!! WARNING !!!!!  You have specified a range"// ! Warning Message
     2              " for omega_i but not a step size.  A default"//    !
     3              " step size of 0.01 eV will be used"                !
         step_i=ceiling((omegaimax-omegaimin)/0.01)                     !
       else                                                             !
         step_i=ceiling((omegaimax-omegaimin)/omegaidel)                ! Number of steps if max and min signal energy are different and delta E is specified
       endif                                                            !
                                                                        !
!       allocate(Rgrid(step_s+1,step_i+1))                              ! Set size of Rgrid array (There were formatting issues with the output when using this array)
       allocate(Rgrid(1,step_i+1))                                      ! Set size of Rgrid array
       allocate(Agrid(step_s+1,step_i+1))                               ! Set size of Agrid array
       allocate(Sgrid(step_s+1))                                        ! Set size of Sgrid array
       allocate(Igrid(step_i+1))                                        ! Set size of Igrid array
       allocate(Rgrid_deg(step_i+1))                                    ! Set size of Rgrid_deg array
                                                                        !
       sEIG=SIZE(EIG)                                                   ! Size of EIG array
       allocate(aGAMMA(sEIG))                                           ! Set size of aGAMMA array (GAMMA values for each eigenenergy)
       iGAMMA=iGAMMA/27.211386245981                                    ! Convert GAMMA from eV to a.u.
       aGAMMA=[real(0), (iGAMMA,i=1,sEIG-1)]                            ! Make aGAMMA array
       ng=MINLOC(EIG,DIM=1)                                             ! Determine index of lowest eigenenergy in EIG array
       Tent=Tent/2.4188843265864E-17                                    ! Convert Tent from s to a.u.
       V=(/ 4,-1,-1,-1,4,-1,-1,-1,4 /)                                  !
       M=reshape(V,(/ 3,3 /))                                           !
       M=M/30                                                           ! Polarizability Prefactor
       V=(/ 1,0,0,0,1,0,0,0,1 /)                                        ! Identity Matrix
       EIG=EIG/27.211386245981                                          ! Convert eigenenergies from eV to a.u.
                                                                        !
!!!!!! END Initial Variable Set Up for ETPA Calculation !!!!!!!!!!!!!!!!!

!!!!!! ETPA Degenerate Probability Calculation !!!!!!!!!!!!!!!!!!!!!!!!!!
                                                                        ! 
       do h=1,step_i+1                                                  ! Loop over all idler energies
         aveomegai=omegaimin+((h-1)*omegaidel)                          ! Idler energy for calculation
         Igrid(h)=aveomegai                                             !
         omegap=2*aveomegai                                             ! Pump energy for calculation
         aveomegai=aveomegai/27.211386245981                            ! Convert idler energy from eV to a.u.
         omegap=omegap/27.211386245981                                  ! Convert pump energy from eV to a.u.
         Stemp=0                                                        !
                                                                        !
         do nf=1,sEIG                                                   ! Loop over all final state eigenenergies
           if (EIG(nf)>EIG(ng)) then                                    ! Select final state eigenenergies that are larger than the ground state eigenenergy
             X=0                                                        !
             do ne=1,sEIG                                               ! Loop over all intermediate state eigenenergies
               if (EIG(nf)>EIG(ne)) then                                ! Select intermediate state eigenenergies that are smaller than the final state eigenenergy
                 if ( EIG(ne)>EIG(ng)) then                             ! Select intermediate state eigenenergies that are larger than the ground state eigenenergy
                   MUeg=(/ MU(ne,ng,1),MU(ne,ng,2),MU(ne,ng,3) /)       ! Select ground to intermediate transition dipole moments
                   MUfe=(/ MU(nf,ne,1),MU(nf,ne,2),MU(nf,ne,3) /)       ! Select intermediate to final transition dipole moments
                   k=0                                                  ! Loop counter for Kronecker product
                   do j=1,3                                             ! Calculate Kronecker product of dipole moments
                     do i=1,3                                           !
                       k=k+1                                            !
                       MUkron(k)=MUeg(j)*MUfe(i)                        ! Kronecker product of dipole moments
                     enddo                                              !
                   enddo                                                !
                   X=X+(MUkron*((exp(Tent*(aveomegai-EIG(ne)+EIG(ng)+   ! Calculate X array 
     2               (imag*aGAMMA(ne))))-1)/((omegap-EIG(nf)+EIG(ng)+   !
     3               (imag*aGAMMA(nf)))*(Tent*(aveomegai-EIG(ne)+       !
     4               EIG(ng)+(imag*aGAMMA(ne)))))))                     !
                 endif                                                  !
               endif                                                    !
             enddo                                                      !
             Z = spread(X,2,9)*spread(conjg(X),1,9)                     ! Calculate Z array
             Stemp(1)=Stemp(1)+Z(1,1)+Z(5,1)+Z(9,1)+Z(1,5)+Z(5,5)+      ! Calculate Stemp array
     2                Z(9,5)+Z(1,9)+Z(5,9)+Z(9,9)                       !   I have skipped several steps in the math to get to this point.
             Stemp(2)=Stemp(2)+Z(1,1)+Z(2,2)+Z(3,3)+Z(4,4)+Z(5,5)+      !   If you want to see a more step by step method look at the commented block at the end of the file.
     2                Z(6,6)+Z(7,7)+Z(8,8)+Z(9,9)                       !     Basically the matrix multiplication of the V and Z arrays then dot product of that outcome with the V array
             Stemp(3)=Stemp(3)+Z(1,1)+Z(2,4)+Z(3,7)+Z(4,2)+Z(5,5)+      !       V=[1 0 0 0 1 0 0 0 1]
     2                Z(6,8)+Z(7,3)+Z(8,6)+Z(9,9)                       !     The Z array elements are shifted in different ways for the different elements of the Stemp array.
           endif                                                        !
         enddo                                                          !
         Sepsilon(1)=dot_product(epsilons,epsiloni)*                    ! Calculate Sepsilon array
     2               dot_product(conjg(epsilons),conjg(epsiloni))       !   Array is based on the polarization of the signal and idler
         Sepsilon(2)=dot_product(epsilons,conjg(epsilons))*             !
     2               dot_product(epsiloni,conjg(epsiloni))              !
         Sepsilon(3)=dot_product(epsilons,conjg(epsiloni))*             !
     2               dot_product(epsiloni,conjg(epsilons))              !
                                                                        !
         Mepsilon=matmul(Sepsilon,M)                                    ! Add Polarization prefactors into the polarization we are using
         S=dot_product(Mepsilon,Stemp)                                  ! Calculate ETPA probability
                                                                        !
         Rgrid_deg(h)=real(S)                                           ! Save degenerate ETPA probability
       enddo                                                            ! End degenerate only ETPA calculation
                                                                        !
!       open(99,file="Rgrid_deg",status='replace')                       ! Open degenerate ETPA output file
!       do i=1,step_i+1                                                  !
!         write(99,"(F20.16,ES26.16E0)") Igrid(i),Rgrid_deg(i)           ! Write degenerate ETPA data to output file
!       enddo                                                            !
!       close(99)                                                        ! Close degenerate ETPA output file
                                                                        !
!!!!!! END ETPA Degenerate Probability Calculation !!!!!!!!!!!!!!!!!!!!!!

!!!!!! ETPA Nondegenerate Probability Calculation !!!!!!!!!!!!!!!!!!!!!!!
                                                                        ! 
       open(96,file="Rgrid_nondeg",status='replace')                    ! Open nondegenerate ETPA output file
       do h=1,step_s+1                                                  ! Loop over all idler energies
         aveomegas=omegasmin+((h-1)*omegasdel)                          ! Signal energy for calculation
         Sgrid(h)=aveomegas                                             !
         Rgrid=0                                                        !
         do l=1,step_i+1                                                ! Loop over all signal energies
           aveomegai=omegaimin+((l-1)*omegaidel)                        ! Idler energy for calculation
           omegap=aveomegai+aveomegas                                   ! Pump energy for calculation
           Igrid(l)=aveomegai                                           !
           aveomegai=aveomegai/27.211386245981                          ! Convert idler energy from eV to a.u.
           omegap=omegap/27.211386245981                                ! Convert pump energy from eV to a.u.
           Stemp=0                                                      !
                                                                        !
           do nf=1,sEIG                                                 ! Loop over all final state eigenenergies
             if (EIG(nf)>EIG(ng)) then                                  ! Select final state eigenenergies that are larger than the ground state eigenenergy
               X=0                                                      !
               do ne=1,sEIG                                             ! Loop over all intermediate state eigenenergies
                 if (EIG(nf)>EIG(ne)) then                              ! Select intermediate state eigenenergies that are smaller than the final state eigenenergy
                   if ( EIG(ne)>EIG(ng)) then                           ! Select intermediate state eigenenergies that are larger than the ground state eigenenergy
                     MUeg=(/ MU(ne,ng,1),MU(ne,ng,2),MU(ne,ng,3) /)     ! Select ground to intermediate transition dipole moments
                     MUfe=(/ MU(nf,ne,1),MU(nf,ne,2),MU(nf,ne,3) /)     ! Select intermediate to final transition dipole moments
                     k=0                                                ! Loop counter for Kronecker product
                     do j=1,3                                           ! Calculate Kronecker product of dipole moments
                       do i=1,3                                         !
                         k=k+1                                          !
                         MUkron(k)=MUeg(j)*MUfe(i)                      ! Kronecker product of dipole moments
                       enddo                                            !
                     enddo                                              !
                     X=X+(MUkron*((exp(Tent*(aveomegai-EIG(ne)+EIG(ng)+ ! Calculate X array
     2                 (imag*aGAMMA(ne))))-1)/((omegap-EIG(nf)+EIG(ng)+ !
     3                 (imag*aGAMMA(nf)))*(Tent*(aveomegai-EIG(ne)+     !
     4                 EIG(ng)+(imag*aGAMMA(ne)))))))                   !
                   endif                                                !
                 endif                                                  !
               enddo                                                    !
               Z = spread(X,2,9)*spread(conjg(X),1,9)                   ! Calculate Z array
               Stemp(1)=Stemp(1)+Z(1,1)+Z(5,1)+Z(9,1)+Z(1,5)+Z(5,5)+    ! Calculate Stemp array
     2                  Z(9,5)+Z(1,9)+Z(5,9)+Z(9,9)                     !   I have skipped several steps in the math to get to this point.
               Stemp(2)=Stemp(2)+Z(1,1)+Z(2,2)+Z(3,3)+Z(4,4)+Z(5,5)+    !   If you want to see a more step by step method look at the commented block at the end of the file.
     2                  Z(6,6)+Z(7,7)+Z(8,8)+Z(9,9)                     !     Basically the matrix multiplication of the V and Z arrays then dot product of that outcome with the V array
               Stemp(3)=Stemp(3)+Z(1,1)+Z(2,4)+Z(3,7)+Z(4,2)+Z(5,5)+    !       V=[1 0 0 0 1 0 0 0 1]
     2                  Z(6,8)+Z(7,3)+Z(8,6)+Z(9,9)                     !     The Z array elements are shifted in different ways for the different elements of the Stemp array.
             endif                                                      !
           enddo                                                        !
           Sepsilon(1)=dot_product(epsilons,epsiloni)*                  !
     2                 dot_product(conjg(epsilons),conjg(epsiloni))     ! Calculate Sepsilon array
           Sepsilon(2)=dot_product(epsilons,conjg(epsilons))*           ! Array is based on the polarization of the signal and idler
     2                 dot_product(epsiloni,conjg(epsiloni))            !
           Sepsilon(3)=dot_product(epsilons,conjg(epsiloni))*           !
     2                 dot_product(epsiloni,conjg(epsilons))            !
                                                                        !
           Mepsilon=matmul(Sepsilon,M)                                  ! Add Polarization prefactors into the polarization we are using
           S=dot_product(Mepsilon,Stemp)                                ! Calculate ETPA probabliity
                                                                        !
           Rgrid(1,l)=real(S)                                           ! Save nondegenerate ETPA probablility
           Agrid(h,l)=aimag(S)                                          ! Save imaginary part of S
         enddo                                                          !
         write(96,*) Rgrid                                              ! Write nondegenerate ETPA data to output file
       enddo                                                            !
                                                                        !
       open(98,file="Igrid_nondeg",status='replace')                    ! Open grid of idler energies output file
       do i=1,step_i+1                                                  !
         write(98,"(F22.16)") Igrid(i)                                  ! Write grid of idler energies to output file
       enddo                                                            !
       close(98)                                                        ! Close grid of idler energies output file
       open(97,file="Sgrid_nondeg",status='replace')                    ! Open grid of signal energies output file
!       write(out_format,"(A2,I0,A11)") '"(',step_i+1,'ES16.7E0)"'      ! Format for nondegenerate ETPA output (This did not work correctly)
       do i=1,step_s+1                                                  !
!         write(96,out_format) Rgrid(i,:)                               ! Write nondegenerate ETPA data to output file (This did not work correctly)
         write(97,"(F22.16)") Sgrid(i)                                  ! Write grid of signal energies to output file
       enddo                                                            !
       close(96)                                                        ! Close nondegenerate ETPA output file
       close(97)                                                        ! Close grid of signal energies output file
                                                                        !
!!!!!! END ETPA Nondegenerate Probability Calculation !!!!!!!!!!!!!!!!!!!


       end

!!!!!! I have written this in a more consise manner !
!!!!!! in the code above, but want to keep this in  !
!!!!!! case it is ever needed.  It also gives an    !
!!!!!! easier to understand look at the array       !
!!!!!! permutation that is being done to calculate  !
!!!!!! the Stemp variable.                          !
!                                                   !
!!!!!! If you want to use this code, the ZZ         !
!!!!!! variable will need to be declared            !
!                                                   !
!         Stemp(1)=dot_product(matmul(V,Z),V)       !
!         ZZ(1:3,1)=Z(1:3,1)                        !
!         ZZ(4:6,1)=Z(1:3,2)                        !
!         ZZ(7:9,1)=Z(1:3,3)                        !
!         ZZ(1:3,2)=Z(4:6,1)                        !
!         ZZ(4:6,2)=Z(4:6,2)                        !
!         ZZ(7:9,2)=Z(4:6,3)                        !
!         ZZ(1:3,3)=Z(7:9,1)                        !
!         ZZ(4:6,3)=Z(7:9,2)                        !
!         ZZ(7:9,3)=Z(7:9,3)                        !
!         ZZ(1:3,4)=Z(1:3,4)                        !
!         ZZ(4:6,4)=Z(1:3,5)                        !
!         ZZ(7:9,4)=Z(1:3,6)                        !
!         ZZ(1:3,5)=Z(4:6,4)                        !
!         ZZ(4:6,5)=Z(4:6,5)                        !
!         ZZ(7:9,5)=Z(4:6,6)                        !
!         ZZ(1:3,6)=Z(7:9,4)                        !
!         ZZ(4:6,6)=Z(7:9,5)                        !
!         ZZ(7:9,6)=Z(7:9,6)                        !
!         ZZ(1:3,7)=Z(1:3,7)                        !
!         ZZ(4:6,7)=Z(1:3,8)                        !
!         ZZ(7:9,7)=Z(1:3,9)                        !
!         ZZ(1:3,8)=Z(4:6,7)                        !
!         ZZ(4:6,8)=Z(4:6,8)                        !
!         ZZ(7:9,8)=Z(4:6,9)                        !
!         ZZ(1:3,9)=Z(7:9,7)                        !
!         ZZ(4:6,9)=Z(7:9,8)                        !
!         ZZ(7:9,9)=Z(7:9,9)                        !
!         Stemp(2)=dot_product(matmul(V,ZZ),V)      !
!         ZZ(1:3,1)=Z(1:3,1)                        !
!         ZZ(4:6,1)=Z(1:3,4)                        !
!         ZZ(7:9,1)=Z(1:3,7)                        !
!         ZZ(1:3,2)=Z(4:6,1)                        !
!         ZZ(4:6,2)=Z(4:6,4)                        !
!         ZZ(7:9,2)=Z(4:6,7)                        !
!         ZZ(1:3,3)=Z(7:9,1)                        !
!         ZZ(4:6,3)=Z(7:9,4)                        !
!         ZZ(7:9,3)=Z(7:9,7)                        !
!         ZZ(1:3,4)=Z(1:3,2)                        !
!         ZZ(4:6,4)=Z(1:3,5)                        !
!         ZZ(7:9,4)=Z(1:3,8)                        !
!         ZZ(1:3,5)=Z(4:6,2)                        !
!         ZZ(4:6,5)=Z(4:6,5)                        !
!         ZZ(7:9,5)=Z(4:6,8)                        !
!         ZZ(1:3,6)=Z(7:9,2)                        !
!         ZZ(4:6,6)=Z(7:9,5)                        !
!         ZZ(7:9,6)=Z(7:9,8)                        !
!         ZZ(1:3,7)=Z(1:3,3)                        !
!         ZZ(4:6,7)=Z(1:3,6)                        !
!         ZZ(7:9,7)=Z(1:3,9)                        !
!         ZZ(1:3,8)=Z(4:6,3)                        !
!         ZZ(4:6,8)=Z(4:6,6)                        !
!         ZZ(7:9,8)=Z(4:6,9)                        !
!         ZZ(1:3,9)=Z(7:9,3)                        !
!         ZZ(4:6,9)=Z(7:9,6)                        !
!         ZZ(7:9,9)=Z(7:9,9)                        !
!         Stemp(3)=dot_product(matmul(V,ZZ),V)      !
!                                                   !
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
